export class Stat {
    public taskId: number;
    public pid: number;
    public mem: {
        rss: number;
        heapTotal: number;
        heapUsed: number;
        external: number
    };
    public counters: {
        stats: number;
        speakers: number;
        sessions: number
    };
    public uptime: number;
    public hostName: string;
    public webTaskId: string;
}
