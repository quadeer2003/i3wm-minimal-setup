<script lang="ts">
  let { title = 'dotfiles' } = $props<{ title?: string }>();
</script>

<nav class="sticky top-0 z-30 py-2 md:py-3 backdrop-blur">
  <div class="mx-auto max-w-7xl px-3 md:px-4 py-2 flex items-center justify-between card bg-background/90">
    <a href="/" class="text-lg md:text-xl font-heading flex-shrink-0">{title}</a>
    
    <div class="flex items-center gap-3 ml-auto">
      <div class="flex items-center gap-3">
        <a href="/configs" class="btn btn-alt text-sm h-9 px-3 py-1">Configs</a>
        <a href="https://github.com/quadeer2003/i3wm-minimal-setup" target="_blank" rel="noopener" class="btn text-sm h-9 px-4 py-1">GitHub</a>
      </div>
    </div>
  </div>
</nav>

<style>
  nav { -webkit-backdrop-filter: blur(8px); backdrop-filter: blur(8px); }
</style>
