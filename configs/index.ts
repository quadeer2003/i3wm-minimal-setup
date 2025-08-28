import i3raw from './i3.config?raw';
import kittyraw from './kitty.conf?raw';
import fishraw from './fish.config?raw';

export interface ConfigMeta {
  id: string;
  name: string;
  description: string;
  filename: string;
  language: string;
  raw: string;
}

export const configs: ConfigMeta[] = [
  {
    id: 'i3',
    name: 'i3 WM',
    description: 'Window manager core configuration.',
    filename: 'i3.config',
    language: 'i3',
    raw: i3raw
  },
  {
    id: 'kitty',
    name: 'Kitty Terminal',
    description: 'Terminal emulator settings.',
    filename: 'kitty.conf',
    language: 'conf',
    raw: kittyraw
  },
  {
    id: 'fish',
    name: 'Fish Shell',
    description: 'Shell configuration and handy functions.',
    filename: 'config.fish',
    language: 'fish',
    raw: fishraw
  }
];

export function getConfig(id: string) {
  return configs.find((c) => c.id === id);
}
