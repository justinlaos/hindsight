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
      'grey': '#9E9E9E',
      'dark-grey': '#6b6b6b',
      'light-grey': '#EFEFEF',
      'white': '#ffffff',
      'slate': '#121212'
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
