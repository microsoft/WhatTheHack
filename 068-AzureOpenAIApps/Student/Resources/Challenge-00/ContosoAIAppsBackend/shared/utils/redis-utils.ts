import { createClient, RedisClientType, RedisDefaultModules, RedisFunctions, RedisModules, RedisScripts } from 'redis';

/**
 * CacheUtil
 *
 * This is intended to be used for caching data within Azure Cache for Redis
 */
export class RedisUtil {
  // Whether the connection has been closed
  private closed = false;

  // prepares the value of the connection protocol (secure)
  private static readonly PROTOCOL = 'redis' + 's';

  /**
   * The client instance
   */
  private readonly client: RedisClientType<RedisDefaultModules & RedisModules, RedisFunctions, RedisScripts>;

  /**
   * Whether this client is connected
   */
  private connected = false;

  /**
   * CacheUtil Constructor
   */
  protected constructor() {
    // Retrieves the Configuration
    const cacheHostName: string = process.env['REDIS_HOST'];
    const cacheHostPort: number = +process.env['REDIS_PORT'];
    const cachePassword: string = process.env['REDIS_PASSWORD'];

    // Prepares the URL
    const cacheURL = RedisUtil.PROTOCOL + '://' + cacheHostName + ':' + cacheHostPort;

    // Sets up the configuration
    const clientOptions = { url: cacheURL, password: cachePassword };

    this.connected = false;

    // Instantiate the Redis client
    this.client = createClient(clientOptions);

    // Watch all the possible events from the client
    this.client.on('connect', () => console.info('Redis Client Connecting to Server'));
    this.client.on('ready', () => console.info('Redis Client is Ready for Use'));
    this.client.on('end', () => console.error('Redis Client Connection Closed'));
    this.client.on('error', err => console.error('Redis Client Error', err));
    this.client.on('reconnecting', () => console.warn('Redis Client Reconnecting'));
  }

  /**
   * Returns Connection Identifier Information about the Client
   *
   * @returns the client id information
   */
  public async getClientId() {
    return await this.getClient().clientId();
  }

  /**
   * Returns a Fresh Instance of a Cache Util Object
   *
   * @param host - the hostname
   * @param port - the port number
   * @param password - the password to access the service
   * @returns the CacheUtil instance
   */
  public static async getInstance(host: string, port: number, password: string): Promise<RedisUtil> {
    const cacheInstance = await new RedisUtil().init();
    const info = await cacheInstance.getClientId();
    console.log('Client Info:');
    console.log(info);
    return cacheInstance;
  }

  /**
   * Returns the Redis Client
   *
   * @returns the redis client
   */
  public getClient() {
    return this.client;
  }

  /**
   * Resets the connection state to false
   */
  public reset() {
    this.connected = false;
  }

  /**
   * Flushes all pending requests and closes the client connection
   *
   * This should only be invoked after we no longer need the Cache Util.
   * Any other scenario may result in unexpected behaviors from the calling code
   *
   * @returns void
   */
  public async close() {
    if (this.closed) {
      console.info('Connection has already been closed');
      return;
    }
    this.reset();
    const info = await this.getClientId();
    console.log('Quitting with Client Info:');
    console.log(info);
    await this.client.quit();
    console.log('Redis Client has Quit');
    this.closed = true;
  }

  /**
   * Initializes & Connects the Client to Server
   *
   * @returns the current object
   */
  public async init() {
    return await this.connectIfNotConnected();
  }

  /**
   * Connects the Client to Server
   *
   * @returns the current object
   */
  private async connectClient() {
    try {
      this.connected = true;
      await this.client.connect();
    } catch (e) {
      console.log(e);
    }
    return this;
  }

  /**
   * Connects the Client if it is not Connected
   */
  private async connectIfNotConnected() {
    if (false === this.connected) {
      await this.connectClient();
    }
    return this;
  }

  /**
   * Stores Value Associated with the Key
   *
   * @param key - the key
   * @param value - the value
   * @returns the current object
   */
  public async set(key: string, value: string): Promise<RedisUtil> {
    await this.connectIfNotConnected();
    await this.client.set(key, value);
    return this;
  }

  /**
   * Stores Value Associated with the Key
   *
   * @param key - the key
   * @param value - the value
   * @param expiration - number of seconds to cache the data
   * @returns the current object
   */
  public async setWithExpiration(key: string, value: string, expiration: number): Promise<RedisUtil> {
    await this.connectIfNotConnected();
    await this.client.setEx(key, expiration, value);
    return this;
  }

  /**
   * Stores Value Associated with the Key
   *
   * @param key - the key
   * @param value - the value
   * @returns the current object
   */
  public async setJson<T>(key: string, value: T): Promise<RedisUtil> {
    const jsonValue = JSON.stringify(value);
    return await this.set(key, jsonValue);
  }

  /**
   * Stores Value Associated with the Key
   *
   * @param key - the key
   * @param value - the value
   * @param expiration - the expiration in seconds
   * @returns the current object
   */
  public async setJsonWithExpiration<T>(key: string, value: T, expiration: number): Promise<RedisUtil> {
    const jsonValue = JSON.stringify(value);
    return await this.setWithExpiration(key, jsonValue, expiration);
  }

  /**
   * Retrieves the Value for the Key
   * @param key - the lookup key
   * @returns the value for the key
   */
  public async get(key: string): Promise<string> {
    await this.connectIfNotConnected();
    return await this.client.get(key);
  }

  /**
   * Scans for the Prefix
   *
   * This method scans for keys matching the prefix* and then returns all the matching keys
   *
   * @param pattern - the lookup prefix or pattern
   *
   * @returns the keys found for the specified pattern
   */
  public async scan(pattern: string): Promise<string[]> {
    await this.connectIfNotConnected();

    const count = 1024;
    const results: string[] = [];
    const iteratorParams = {
      MATCH: pattern,
      COUNT: count,
    };

    for await (const key of this.client.scanIterator(iteratorParams)) {
      results.push(key);
    }

    return results;
  }

  /**
   * Removes the Value for the Key
   * @param key - the lookup key
   * @returns 1 on success and 0 on failure
   */
  public async delete(key: string): Promise<number> {
    await this.connectIfNotConnected();
    return await this.client.del(key);
  }

  /**
   * Retrieves the Value for the Key
   * @param key - the lookup key
   * @returns the value for the key
   */
  public async getJson<T>(key: string): Promise<T> {
    const jsonString = await this.get(key);
    return <T>JSON.parse(jsonString);
  }

  /**
   * Checks if the Key Exists
   *
   * @param key - the lookup key
   * @returns whether or not the key exists
   */
  public async keyExists(key: string): Promise<boolean> {
    await this.connectIfNotConnected();
    return (await this.client.exists(key)) > 0;
  }

  /**
   * Removes all Entry from Cache
   */
  public async flushAll() {
    return await this.client.flushAll();
  }

  /**
   * Retrieving All Cached Data
   *
   * @returns the cached data
   */
  public async getAll(): Promise<{ [p: string]: any }> {
    const response: { [key: string]: any } = {};

    for await (const currentKey of this.client.scanIterator()) {
      const currentValue = await this.getJson<any>(currentKey);
      console.log('currentValue=' + currentValue);
      response[currentKey] = currentValue;
    }

    return response;
  }

  public async push(key: string, value: string | string[]) {
    return await this.client.rPush(key, value);
  }

  public async pushJson<T>(key: string, value: T) {
    const jsonValue = JSON.stringify(value);
    return await this.push(key, jsonValue);
  }

  public async range(key: string) {
    const startPosition: number = 0; // the first item in the list
    const stopPosition: number = -1; // the last item in the list
    return await this.client.lRange(key, startPosition, stopPosition);
  }

  public async rangeJson<T>(key: string) {
    const rawResults = await this.range(key);
    const results: T[] = [];
    let i = 0;

    for (i = 0; i < rawResults.length; i++) {
      const currentItem = rawResults[i];
      const jsonItem = JSON.parse(currentItem) as T;
      results.push(jsonItem);
    }

    return results;
  }
}
