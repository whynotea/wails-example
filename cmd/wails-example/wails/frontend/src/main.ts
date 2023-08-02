import { ViteSSG } from 'vite-ssg'
import { setupLayouts } from 'virtual:generated-layouts'
import { routes } from 'vue-router/auto/routes'
import { createWebHistory } from 'vue-router'
import App from './App.vue'
import type { UserModule } from './types'

import './styles'

// Workaround for https://github.com/wailsapp/wails/issues/2262
if (!('go' in window))
  location.replace('/')

// https://github.com/antfu/vite-ssg
export const createApp = ViteSSG(
  App,
  {
    routes: setupLayouts(routes),
    base: import.meta.env.BASE_URL,
    history: createWebHistory(import.meta.env.BASE_URL),
    scrollBehavior(to) {
      if (to.hash) {
        const id = to.hash.slice(1, to.hash.length)
        const el = document.getElementById(id)
        el?.scrollIntoView({ behavior: 'smooth' })
      }
    },
  },
  (ctx) => {
    // install all modules under `modules/`
    Object.values(import.meta.glob<{ install: UserModule }>('./modules/*.ts', { eager: true }))
      .forEach(i => i.install?.(ctx))
  },
)
