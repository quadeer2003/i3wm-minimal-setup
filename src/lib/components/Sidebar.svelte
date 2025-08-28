<script lang="ts">
  import type { ConfigMeta } from '$lib/configs';
  let { items = [], active = null } = $props<{ items?: ConfigMeta[]; active?: string | null }>();
  let mobileMenuOpen = $state(false);
</script>

<aside class="w-60 shrink-0 hidden lg:block p-4 space-y-4">
  <div class="card p-4 space-y-3 bg-secondary-background/90 backdrop-blur">
    <h2 class="text-xs font-heading uppercase tracking-wider opacity-70">Configs</h2>
    <ul class="space-y-2">
      {#each items as item}
        <li>
          <a href={`/configs/${item.id}`} data-sveltekit-preload-data="hover" class={`block text-sm font-semibold px-3 py-2 rounded-md border-2 border-border shadow-[var(--shadow)] ${active === item.id ? 'bg-main text-main-foreground' : 'bg-secondary-background hover:-translate-y-0.5 transition-transform'}`}>{item.name}</a>
        </li>
      {/each}
    </ul>
  </div>
</aside>

<div class="lg:hidden p-3 md:p-4">
  <button 
    class="btn btn-alt text-sm h-9 px-4 py-1 w-full"
    onclick={() => mobileMenuOpen = !mobileMenuOpen}
  >
    {mobileMenuOpen ? 'Hide Configs' : 'Show Configs'}
  </button>
  
  {#if mobileMenuOpen}
    <div class="mt-4 card p-4 space-y-3 bg-secondary-background/90 backdrop-blur">
      <h2 class="text-xs font-heading uppercase tracking-wider opacity-70">Configs</h2>
      <ul class="space-y-2">
        {#each items as item}
          <li>
            <a 
              href={`/configs/${item.id}`} 
              data-sveltekit-preload-data="hover" 
              class={`block text-sm font-semibold px-3 py-2 rounded-md border-2 border-border shadow-[var(--shadow)] ${active === item.id ? 'bg-main text-main-foreground' : 'bg-secondary-background hover:-translate-y-0.5 transition-transform'}`}
              onclick={() => mobileMenuOpen = false}
            >
              {item.name}
            </a>
          </li>
        {/each}
      </ul>
    </div>
  {/if}
</div>
