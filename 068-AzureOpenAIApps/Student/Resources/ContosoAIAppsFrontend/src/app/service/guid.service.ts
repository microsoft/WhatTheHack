
import { v4 as uuidv4 } from 'uuid';

export class GuidService
{
    public static generateGuid()
    {
        return uuidv4()
    }
}