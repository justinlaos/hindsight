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
      'primary': '#21a656',
      'dark-primary': '#164629',
      'light-primary': '#62ea98',
      'darkest-grey': '#181818',
      'dark-grey': '#6b6b6b',
      'grey': '#9E9E9E',
      'grey-ish': '#e0e0e0',
      'light-grey': '#EFEFEF',
      'really-light-grey': '#f2f3f4',
      'black': '#000000',
      'white': '#ffffff',
      'slate': 'black',
      'yellow': '#FFD700',
      'orange': '#FFAC1C',
      'blue': '#0096FF',
      'red': '#CC0000'
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
