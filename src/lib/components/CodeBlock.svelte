<script lang="ts">
  let { code, language = 'text', filename = null } = $props<{ 
    code: string; 
    language?: string; 
    filename?: string | null; 
  }>();
  let copied = $state(false);
  async function copy() {
    try {
      await navigator.clipboard.writeText(code);
      copied = true;
      setTimeout(() => (copied = false), 1800);
    } catch (e) {
      console.error('Copy failed', e);
    }
  }
  function download() {
    const blob = new Blob([code], { type: 'text/plain' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = filename || 'config.txt';
    a.click();
    URL.revokeObjectURL(a.href);
  }
</script>

<div class="relative card overflow-hidden">
  <div class="flex items-center gap-2 px-3 md:px-4 h-10 md:h-11 text-xs font-heading tracking-wide code-header border-b-2 border-border">
    <span class="uppercase text-xs">{language}</span>
    {#if filename}<span class="opacity-80 font-medium text-xs hidden sm:inline">{filename}</span>{/if}
    <div class="ml-auto flex items-center gap-1 md:gap-2">
      <button onclick={copy} class="btn btn-alt text-xs leading-none py-1 px-2 md:px-3">{copied ? 'Copied' : 'Copy'}</button>
      <button onclick={download} class="btn text-xs leading-none py-1 px-2 md:px-3">Download</button>
    </div>
  </div>
  <pre class="overflow-auto p-3 md:p-5 text-xs md:text-[13px] leading-relaxed bg-secondary-background"><code>{code}</code></pre>
</div>

<style>
  pre { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
</style>
