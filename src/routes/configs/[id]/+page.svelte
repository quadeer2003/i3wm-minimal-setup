<script lang="ts">
  import { configs } from '../../../../configs';
  import type { PageData } from './$types';
  import Nav from '$lib/components/Nav.svelte';
  import Sidebar from '$lib/components/Sidebar.svelte';
  import CodeBlock from '$lib/components/CodeBlock.svelte';
  let { data } = $props<{ data: PageData }>();
  const cfg = $derived(data.config);
</script>

<Nav />
<div class="mx-auto max-w-7xl w-full px-3 md:px-4 lg:px-8">
  <div class="flex flex-col lg:flex-row lg:gap-6">
    <Sidebar items={configs} active={cfg?.id} />
    <main class="flex-1 py-4 md:py-10 space-y-6 md:space-y-10 min-w-0">
      {#if !cfg}
        <section class="card p-6 md:p-10 bg-secondary-background/90 backdrop-blur space-y-4">
          <h1 class="text-2xl md:text-4xl font-heading">Not found</h1>
          <p class="text-sm">Unknown config id.</p>
        </section>
      {:else}
        <section class="card p-6 md:p-10 bg-secondary-background/90 backdrop-blur space-y-5 animate-fade-in-up">
          <h1 class="text-2xl md:text-4xl font-heading leading-none">{cfg.name}</h1>
          <p class="text-xs md:text-sm max-w-2xl opacity-80">{cfg.description}</p>
        </section>
        <CodeBlock code={cfg.raw} language={cfg.language} filename={cfg.filename} />
      {/if}
    </main>
  </div>
</div>
