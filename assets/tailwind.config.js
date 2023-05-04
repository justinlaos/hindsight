// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  darkMode: 'class',
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    colors: {
      'primary': '#2b9455',
      'dark-primary': '#1d663a',
      'light-primary': '#62ea98',
      'darkest-grey': '#181818',
      'dark-grey': '#6b6b6b',
      'grey': '#9E9E9E',
      'grey-ish': '#e0e0e0',
      'light-grey': '#dedede',
      'really-light-grey': '#f2f3f4',
      'black': '#000000',
      'white': '#ffffff',
      'slate': '#121212',
      'yellow': '#FFD700',
      'gold': '#e6be53',
      'orange': '#FFAC1C',
      'blue': '#0096FF',
      'red': '#9A2A2A'
    },
    container: {
      padding: {
        DEFAULT: '0rem',
      },
    },
    extend: {
      fontFamily: {
        sans: ['Poppins'],
      },
   }
  },
  plugins: [
    require('@tailwindcss/forms')
  ]
}
