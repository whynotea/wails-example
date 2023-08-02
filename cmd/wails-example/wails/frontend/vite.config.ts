import path from 'node:path'
import { defineConfig } from 'vite'
import Vue from '@vitejs/plugin-vue'
import generateSitemap from 'vite-ssg-sitemap'
import Layouts from 'vite-plugin-vue-layouts'
import Components from 'unplugin-vue-components/vite'
import AutoImport from 'unplugin-auto-import/vite'
import { VitePWA } from 'vite-plugin-pwa'
import Inspect from 'vite-plugin-inspect'
import Inspector from 'vite-plugin-vue-inspector'
import VueMacros from 'unplugin-vue-macros/vite'
import VueRouter from 'unplugin-vue-router/vite'
import { VueRouterAutoImports } from 'unplugin-vue-router'
import Unfonts from 'unplugin-fonts/vite'

export default defineConfig({
  resolve: {
    alias: {
      '~/': `${path.resolve(__dirname, 'src')}/`,
      '@wails/': `${path.resolve(__dirname, 'wailsjs')}/`,
      '@types': `${path.resolve(__dirname, 'types')}/`,
      '@utils/': `${path.resolve(__dirname, 'utils')}/`,
      '@assets/': `${path.resolve(__dirname, 'src/assets')}/`,
    },
  },
  plugins: [
    // https://github.com/antfu/vite-plugin-inspect
    // Visit http://localhost:3333/__inspect/ to see the inspector
    Inspect({
      build: true,
      outputDir: '.vite-inspect',
    }),

    VueRouter({
      routesFolder: [
        'src/pages',
      ],
      extensions: ['.vue'],
    }),

    VueMacros({
      plugins: {
        vue: Vue({
          include: [/\.vue$/],
          reactivityTransform: true,
        }),
      },
    }),
    Unfonts({
      google: {
        families: [
          'Source Code Pro',
        ],
      },
    }),
  
    // https://github.com/JohnCampionJr/vite-plugin-vue-layouts
    Layouts(),

    // https://github.com/antfu/unplugin-auto-import
    AutoImport({
      imports: [
        'vue',
        VueRouterAutoImports,
        'vue/macros',
        '@vueuse/head',
        '@vueuse/core',
      ],
      dts: 'src/auto-imports.d.ts',
      dirs: [
        'src/composables/**',
        'src/stores/**',
      ],
      vueTemplate: true,
    }),

    // https://github.com/antfu/unplugin-vue-components
    Components({
      dirs: ['src/components', 'src/layouts'],
      // allow auto load markdown components under `./src/components/`
      extensions: ['vue'],
      // allow auto import and register components used in markdown
      include: [/\.vue$/, /\.vue\?vue/],
      dts: 'src/components.d.ts',
    }),

    // https://github.com/antfu/vite-plugin-pwa
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.svg', 'safari-pinned-tab.svg'],
      manifest: {
        name: 'Wails Example',
        short_name: 'Wails Example',
        theme_color: '#ffffff',
        icons: [
          {
            src: '/pwa-192x192.png',
            sizes: '192x192',
            type: 'image/png',
          },
          {
            src: '/pwa-512x512.png',
            sizes: '512x512',
            type: 'image/png',
          },
          {
            src: '/pwa-512x512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'any maskable',
          },
        ],
      },
    }),

    // https://github.com/webfansplz/vite-plugin-vue-inspector
    Inspector({
      toggleButtonVisibility: 'never',
    }),
  ],

  // https://github.com/vitest-dev/vitest
  test: {
    include: ['test/**/*.test.ts'],
    environment: 'jsdom',
    deps: {
      inline: ['@vue', '@vueuse', 'vue-demi'],
    },
  },

  // https://github.com/antfu/vite-ssg
  ssgOptions: {
    script: 'async',
    formatting: 'prettify',
    dirStyle: 'nested',
    onFinished() { generateSitemap() },
    mock: true,
  },

  ssr: {
    // TODO: workaround until they support native ESM
    noExternal: ['workbox-window'],
  },
})
