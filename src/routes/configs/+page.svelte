<script lang="ts">
  import { configs } from '../../../configs';
  import Nav from '$lib/components/Nav.svelte';
  import Sidebar from '$lib/components/Sidebar.svelte';
  import CodeBlock from '$lib/components/CodeBlock.svelte';
  let first = configs[0];
</script>

<Nav />
<div class="mx-auto max-w-7xl w-full px-3 md:px-4 lg:px-8">
  <div class="flex flex-col lg:flex-row lg:gap-6">
    <Sidebar items={configs} active={null} />
    <main class="flex-1 py-4 md:py-8 space-y-8 md:space-y-12 min-w-0">
      <section class="card p-4 md:p-8 bg-secondary-background/90 backdrop-blur space-y-4 animate-fade-in-up">
        <h1 class="text-2xl md:text-4xl font-heading leading-none">Configs</h1>
        <p class="text-xs md:text-sm max-w-2xl opacity-80">Minimal starter template for sharing i3 / rice related dotfiles. Pick one from the sidebar or explore all below. Replace sample code with your real configuration files.</p>
      </section>
      {#if first}
        <section class="space-y-4 animate-fade-in-up">
          <h2 class="text-lg md:text-xl font-heading tracking-tight flex items-center gap-3"><span class="inline-block px-2 md:px-3 py-1 bg-main text-main-foreground rounded-md border-2 border-border shadow-[var(--shadow)] text-xs md:text-sm">Preview</span> <span class="text-sm md:text-base">{first.name}</span></h2>
          <CodeBlock code={first.raw} language={first.language} filename={first.filename} />
        </section>
      {/if}
      <section class="space-y-6 animate-fade-in-up">
        <h2 class="text-lg md:text-xl font-heading tracking-tight">All files</h2>
        <ul class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-8 list-none !pl-0">
          {#each configs as c}
            <li class="card p-4 md:p-5 bg-secondary-background/90 backdrop-blur space-y-3">
              <h3 class="text-base md:text-lg font-heading">{c.name}</h3>
              <p class="text-xs leading-snug opacity-80 line-clamp-4">{c.description}</p>
              <a href={`/configs/${c.id}`} class="btn btn-alt text-xs">Open</a>
            </li>
          {/each}
        </ul>
      </section>
    </main>
  </div>
</div>
