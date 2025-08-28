import type { PageLoad } from './$types';
import { getConfig } from '$lib/configs';
import { error } from '@sveltejs/kit';

export const load: PageLoad = async ({ params }) => {
  const cfg = getConfig(params.id);
  if (!cfg) {
    throw error(404, 'Config not found');
  }
  return { config: cfg };
};
