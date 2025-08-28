<script lang="ts">
	import Nav from '$lib/components/Nav.svelte';
</script>

<Nav />
<main class="mx-auto max-w-5xl p-4 md:p-8 lg:p-12 space-y-8 md:space-y-10">
	<section class="card p-6 md:p-10 bg-secondary-background/90 backdrop-blur space-y-4 md:space-y-6 animate-fade-in-up">
		<h1 class="text-3xl md:text-5xl font-heading tracking-tight leading-none">ARCH RICE (I3WM) </h1>
		<p class="text-base md:text-lg font-medium max-w-2xl">Here's my minimal i3wm starter rice setup. Clean, functional configs for i3, fish, kitty and more. Feel free to grab what you like and make it your own.</p>
		<div class="flex flex-col sm:flex-row gap-3 md:gap-4">
			<a href="/configs" class="btn text-sm md:text-base text-center">Browse Configs</a>
			<a href="https://github.com/quadeer2003/i3wm-minimal-setup" class="btn btn-alt text-sm md:text-base text-center">GitHub</a>
		</div>
	</section>
	<section class="grid grid-cols-1 md:grid-cols-3 gap-4 md:gap-6">
		<div class="card p-4 md:p-6 space-y-2 animate-fade-in-up [animation-delay:.05s]">
			<h3 class="text-base md:text-lg font-heading">Minimal</h3>
			<p class="text-xs md:text-sm leading-snug opacity-80">Clean, distraction-free setup focused on productivity.</p>
		</div>
		<div class="card p-4 md:p-6 space-y-2 animate-fade-in-up [animation-delay:.1s]">
			<h3 class="text-base md:text-lg font-heading">Functional</h3>
			<p class="text-xs md:text-sm leading-snug opacity-80">Every config serves a purpose. No unnecessary bloat.</p>
		</div>
		<div class="card p-4 md:p-6 space-y-2 animate-fade-in-up [animation-delay:.15s]">
			<h3 class="text-base md:text-lg font-heading">Personal</h3>
			<p class="text-xs md:text-sm leading-snug opacity-80">Tuned to my workflow but adaptable to yours.</p>
		</div>
	</section>
</main>


