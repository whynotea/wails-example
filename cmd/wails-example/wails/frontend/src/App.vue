<script setup lang="ts">

// https://github.com/vueuse/head
// you can use this to manipulate the document head in any components,
// they will be rendered correctly in the html results with vite-ssg
useHead({
  title: 'Wails Example',
  meta: [
    { name: 'description', content: 'Wails Example' },
  ],
  link: [
    {
      rel: 'icon',
      type: 'image/svg+xml',
      href: '/favicon-dark.svg',
    },
  ],
})
</script>

<template lang="pug">
.wails-example
  RouterView(v-slot="{ Component }")
    KeepAlive
      Component(:is="Component")
</template>
