<script setup lang="ts">
definePage({
  meta: {
    title: 'Home',
  },
  alias: ['/'],
})
</script>

<template lang="pug">
.wails-example-home
  |Test
</template>

<style lang="scss">
.wails-example-home {
  width: 100%;
  height: 100%;
  overflow: auto;
  padding: 1em;
}
</style>
