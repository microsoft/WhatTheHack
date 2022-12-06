import { InjectionToken, FactoryProvider } from '@angular/core';

export const WINDOW = new InjectionToken<Window>('window');

const windowProvider: FactoryProvider = {
    provide: WINDOW,
    useFactory: () => window
};

export const WINDOW_PROVIDERS = [
    windowProvider
];