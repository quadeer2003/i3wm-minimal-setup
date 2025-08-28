<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';
	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
	<title>dotfiles starter</title>
	<meta name="description" content="Minimal i3wm rice dotfiles sharing template" />
</svelte:head>

<div class="bg-grainy-green text-foreground transition-colors min-h-screen">
	{@render children?.()}
</div>
