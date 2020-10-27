// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.

export const environment = {
  production: false,
  USERS_RESOURCE_URL: '../users',
  ACCOUNTS_RESOURCE_URL: '../accounts',
  LOGIN_URL: "../login",
  LOGOUT_URL: "../logout",
  AUTHENTICATION_URL: "../authentication"
};
