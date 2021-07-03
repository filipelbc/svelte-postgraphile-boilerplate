<script lang="ts">
  export let name: string;

  import { onMount } from 'svelte';
  import client from './services/api';

  onMount(async () => {
    const foo = await client.createUser({ name: 'foo', password: 'bar' });
    console.log(foo);
  });
</script>

<main>
  <h1>Hello {name}!</h1>
  <p>
    Visit the <a href="https://svelte.dev/tutorial">Svelte tutorial</a> to learn
    how to build Svelte apps.
  </p>
  <button class="button">Click Me!</button>
</main>

<style global lang="scss">
  @import 'main.scss';
</style>
