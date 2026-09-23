<script setup>
import { computed, nextTick, onMounted, onUnmounted, ref, watchEffect } from 'vue'
import { ArrowDown, ArrowLeft, ArrowLeftRight, ArrowRight, ArrowUp, ArrowUpRight, Bike, BriefcaseBusiness, Clapperboard, CodeXml, Map, MessageCircleMore, Music2, Shapes, X } from '@lucide/vue'

const topicIcons = { music: Music2, films: Clapperboard, hobbies: Shapes }
const hobbyIcons = [BriefcaseBusiness, CodeXml, Bike, Music2]
const brandIcons = {
  instagram: { color: '#FF0069', slug: 'instagram' },
  telegram: { color: '#26A5E4', slug: 'telegram' },
  discord: { color: '#5865F2', slug: 'discord' },
  github: { color: '#181717', slug: 'github' },
  mail: { color: '#d92d27', slug: null },
}

const language = ref('sk')
const view = ref('home')
const activeMusic = ref(0)
const activeFilm = ref(0)
const activePhoto = ref(0)
const activeHobby = ref(0)
const activeRoute = ref(0)
const revealedFacts = ref(Array(10).fill(false))
const swipeStart = ref(null)
const swipeType = ref(null)
const swipePointer = ref(null)
const dragX = ref(0)
const contactOpen = ref(false)
const socialModal = ref(null)
const scrollCueUp = ref(false)
let scrollIntentAnchorY = 0
const topicsGrid = ref(null)
const topicScrollLeft = ref(0)
const activeTopic = ref(0)
const scrollPositions = { home: 0, hobbies: 0, music: 0, films: 0, routes: 0 }

const photos = [
  { src: '/photos/cycling-stats.jpg', tone: 'photo-one', alt: 'Nikita v meste' },
  { src: '/photos/water.jpg', tone: 'photo-two', alt: 'Nikita pri graffiti' },
  { src: '/photos/night-stick.jpg', tone: 'photo-three', alt: 'Nikita v noci v lese' },
]

const cyclingRoutes = [
  { src: '/photos/routes/IMG_8948.JPG', distanceMi: 59.3, durationMinutes: 317, roundTrip: true, places: { sk: ['Zvolen', 'Hrinová'], en: ['Zvolen', 'Hrinová'] } },
  { src: '/photos/routes/IMG_8943.JPG', distanceMi: 57.4, durationMinutes: 286, places: { sk: 'okres Trnava loop', en: 'Trnava district loop' } },
  { src: '/photos/routes/IMG_8950.JPG', distanceMi: 45.8, durationMinutes: 396, roundTrip: true, places: { sk: ['Zvolen', 'Banská Štiavnica'], en: ['Zvolen', 'Banská Štiavnica'] } },
  { src: '/photos/routes/IMG_8974.JPG', distanceMi: 40.5, durationMinutes: 202, roundTrip: true, places: { sk: ['Zvolen', 'Žiar nad Hronom'], en: ['Zvolen', 'Žiar nad Hronom'] } },
  { src: '/photos/routes/IMG_8953.JPG', distanceMi: 38.9, durationMinutes: 265, oneWay: true, places: { sk: ['Chimki', 'zelený okruh'], en: ['Khimki', 'green ring'] } },
  { src: '/photos/routes/IMG_8951.JPG', distanceMi: 29.54, durationMinutes: 195, roundTrip: true, places: { sk: ['Zvolen', 'Banská Bystrica'], en: ['Zvolen', 'Banská Bystrica'] } },
  { src: '/photos/routes/IMG_8975.JPG', distanceMi: 18, durationMinutes: 104, places: { sk: 'okres Zvolen loop', en: 'Zvolen district loop' } },
  { src: '/photos/routes/IMG_8952.JPG', distanceMi: 11.15, durationMinutes: 96, roundTrip: true, places: { sk: ['Antalya', 'cyklovýlet'], en: ['Antalya', 'bike ride'] } },
]

const content = {
  sk: {
    titleHello: 'Ahoj,',
    titleName: 'ja som Nikita',
    explore: 'vybrať tému',
    scrollTop: 'späť na začiatok',
    scrollDown: 'ďalšia sekcia',
    contact: 'Napísať mi',
    back: 'späť',
    previous: 'predchádzajúca karta', next: 'ďalšia karta',
    facts: {
      title: 'Fun Facts',
      questions: [
        ['Čierna alebo biela?', 'Čierna', 'Biela', 1],
        ['Hory alebo more?', 'Hory', 'More', 1],
        ['Káva alebo čaj?', 'Káva', 'Čaj', 2],
        ['Ráno alebo noc?', 'Ráno', 'Noc', 1],
        ['Mesto alebo príroda?', 'Mesto', 'Príroda', 2],
        ['Film alebo seriál?', 'Film', 'Seriál', 2],
        ['Mačky alebo psy?', 'Mačky', 'Psy', 2],
        ['Plán alebo spontánnosť?', 'Plán', 'Spontánnosť', 1],
        ['Správy alebo hovory?', 'Správy', 'Hovory', 1],
        ['Leto alebo zima?', 'Leto', 'Zima', 1],
      ],
    },
    socialTitle: 'Kontakt',
    socials: [
      { label: 'Instagram', value: '@geeksaider', href: 'https://instagram.com/geeksaider', icon: 'instagram' },
      { label: 'Telegram', value: '@geeksaider', href: 'https://t.me/geeksaider', icon: 'telegram' },
      { label: 'Discord', value: 'geeksaider', href: 'https://discord.com/users/geeksaider', icon: 'discord' },
      { label: 'GitHub', value: 'geeksaider', href: 'https://github.com/geeksaider', icon: 'github' },
      { label: 'E-mail', value: 'geeksaider@gmail.com', href: 'mailto:geeksaider@gmail.com', icon: 'mail' },
    ],
    menu: {
      music: { title: 'Môj hudobný vkus' },
      films: { title: 'Filmy a seriály' },
      hobbies: { title: 'Hobby' },
    },
    music: {
      title: 'Môj hudobný vkus',
      items: [
        { title: 'Baby One More Time', artist: 'Travis', color: '#cbbca4', cover: 'https://i.ebayimg.com/images/g/Y8QAAOSw7fBhFq8Y/s-l1200.jpg' },
        { title: 'I Smoked Away My Brain', artist: 'A$AP Rocky feat. Imogen Heap & Clams Casino', color: '#aaa9a6', cover: 'https://i.pinimg.com/736x/04/82/f9/0482f940e8df6a89ee541d50575e629f.jpg' },
        { title: 'Everyday', artist: 'A$AP Rocky feat. Rod Stewart, Miguel & Mark Ronson', color: '#d9d5ce', cover: '/photos/covers/everyday.jpg' },
        { title: 'Omen', artist: 'The Prodigy', color: '#ff6b49', cover: 'https://images.universal-music.de/img/assets/165/165942/4/1200/invaders-must-die-0602517955608.jpg' },
        { title: "It Can't Come Quickly Enough", artist: 'Scissor Sisters', color: '#67d9ff', cover: 'https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/36/38/45/363845a9-dc46-1605-dce3-f41b1b11e97d/25UMGIM38812.rgb.jpg/1200x630wp-60.jpg' },
      ],
    },
    films: {
      title: 'Filmy a seriály',
      items: [
        { title: 'Stávka na neistotu', year: '2015', type: 'FILM', color: '#7657ff', cover: '/photos/covers/big-short.jpg' },
        { title: 'Hlúpa láska', year: '2011', type: 'FILM', color: '#ffb2d0', cover: '/photos/covers/crazy-stupid-love.jpg' },
        { title: 'Teória veľkého tresku', year: '2007–2019', type: 'SERIÁL', color: '#e6ff42', cover: '/photos/covers/bbt.jpg' },
        { title: 'Ako som spoznal vašu matku', year: '2005–2014', type: 'SERIÁL', color: '#67d9ff', cover: '/photos/covers/himym.jpg' },
        { title: '10 vecí, ktoré na tebe neznášam', year: '1999', type: 'FILM', color: '#ff6b49', cover: '/photos/covers/10-things.jpg' },
      ],
    },
    hobbies: {
      title: 'Čomu sa venujem',
      routes: 'Moje cyklotrasy', route: 'Cyklotrasa', openRoute: 'Podrobnosti',
      distance: 'vzdialenosť', duration: 'čas', speed: 'priemerná rýchlosť',
      items: [
        { title: 'Práca', color: '#e31e24', photo: '/photos/hobby-work.jpg', photoAlt: 'Nikita v práci', details: 'Pracoval som na viacerých pozíciách, od kuchára až po systémového analytika.' },
        { title: 'Programovanie', color: '#111111', photo: '/photos/programming.jpg', photoAlt: 'Kód na obrazovke notebooku', details: 'Tvorím weby a digitálne produkty.' },
        { title: 'Cyklistika', color: '#f2f2f2', photo: '/photos/hobby-cycling.jpg', photoAlt: 'Nikita s bicyklom', details: 'Moja najdlhšia uložená trasa má 95,4 km.' },
        { title: 'Voľný čas', color: '#8a8a8a', photo: '/photos/mirror.jpg', photoAlt: 'Nikita so slúchadlami v zrkadle', details: '8 rokov som študoval hru na violončele. Hrám na gitare, kedysi som hral v kapele. Rád hrávam volejbal.' },
      ],
    },
  },
  en: {
    titleHello: 'Hi,',
    titleName: "I'm Nikita",
    explore: 'choose a topic', scrollTop: 'back to top', scrollDown: 'next section', contact: 'Message me', back: 'back', previous: 'previous card', next: 'next card',
    facts: {
      title: 'Fun Facts',
      questions: [
        ['Black or white?', 'Black', 'White', 1],
        ['Mountains or sea?', 'Mountains', 'Sea', 1],
        ['Coffee or tea?', 'Coffee', 'Tea', 2],
        ['Morning or night?', 'Morning', 'Night', 1],
        ['City or nature?', 'City', 'Nature', 2],
        ['Film or series?', 'Film', 'Series', 2],
        ['Cats or dogs?', 'Cats', 'Dogs', 2],
        ['Plans or spontaneity?', 'Plans', 'Spontaneity', 1],
        ['Texts or calls?', 'Texts', 'Calls', 1],
        ['Summer or winter?', 'Summer', 'Winter', 1],
      ],
    },
    socialTitle: 'Contact',
    socials: [
      { label: 'Instagram', value: '@geeksaider', href: 'https://instagram.com/geeksaider', icon: 'instagram' },
      { label: 'Telegram', value: '@geeksaider', href: 'https://t.me/geeksaider', icon: 'telegram' },
      { label: 'Discord', value: 'geeksaider', href: 'https://discord.com/users/geeksaider', icon: 'discord' },
      { label: 'GitHub', value: 'geeksaider', href: 'https://github.com/geeksaider', icon: 'github' },
      { label: 'E-mail', value: 'geeksaider@gmail.com', href: 'mailto:geeksaider@gmail.com', icon: 'mail' },
    ],
    menu: {
      music: { title: 'My music taste' },
      films: { title: 'Films & series' },
      hobbies: { title: 'Hobbies' },
    },
    music: {
      title: 'My music taste',
      items: [
        { title: 'Baby One More Time', artist: 'Travis', color: '#cbbca4', cover: 'https://i.ebayimg.com/images/g/Y8QAAOSw7fBhFq8Y/s-l1200.jpg' },
        { title: 'I Smoked Away My Brain', artist: 'A$AP Rocky feat. Imogen Heap & Clams Casino', color: '#aaa9a6', cover: 'https://i.pinimg.com/736x/04/82/f9/0482f940e8df6a89ee541d50575e629f.jpg' },
        { title: 'Everyday', artist: 'A$AP Rocky feat. Rod Stewart, Miguel & Mark Ronson', color: '#d9d5ce', cover: '/photos/covers/everyday.jpg' },
        { title: 'Omen', artist: 'The Prodigy', color: '#ff6b49', cover: 'https://images.universal-music.de/img/assets/165/165942/4/1200/invaders-must-die-0602517955608.jpg' },
        { title: "It Can't Come Quickly Enough", artist: 'Scissor Sisters', color: '#67d9ff', cover: 'https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/36/38/45/363845a9-dc46-1605-dce3-f41b1b11e97d/25UMGIM38812.rgb.jpg/1200x630wp-60.jpg' },
      ],
    },
    films: {
      title: 'Films & series',
      items: [
        { title: 'The Big Short', year: '2015', type: 'FILM', color: '#7657ff', cover: '/photos/covers/big-short.jpg' },
        { title: 'Crazy, Stupid, Love', year: '2011', type: 'FILM', color: '#ffb2d0', cover: '/photos/covers/crazy-stupid-love.jpg' },
        { title: 'The Big Bang Theory', year: '2007–2019', type: 'SERIES', color: '#e6ff42', cover: '/photos/covers/bbt.jpg' },
        { title: 'How I Met Your Mother', year: '2005–2014', type: 'SERIES', color: '#67d9ff', cover: '/photos/covers/himym.jpg' },
        { title: '10 Things I Hate About You', year: '1999', type: 'FILM', color: '#ff6b49', cover: '/photos/covers/10-things.jpg' },
      ],
    },
    hobbies: {
      title: 'What I spend time on',
      routes: 'My cycling routes', route: 'Cycling route', openRoute: 'Details',
      distance: 'distance', duration: 'time', speed: 'average speed',
      items: [
        { title: 'Work', color: '#e31e24', photo: '/photos/hobby-work.jpg', photoAlt: 'Nikita at work', details: 'I have worked in several roles, from cook to systems analyst.' },
        { title: 'Programming', color: '#111111', photo: '/photos/programming.jpg', photoAlt: 'Code on a laptop screen', details: 'I build websites and digital products.' },
        { title: 'Cycling', color: '#f2f2f2', photo: '/photos/hobby-cycling.jpg', photoAlt: 'Nikita with a bicycle', details: 'My longest saved ride is 95.4 km.' },
        { title: 'Free time', color: '#8a8a8a', photo: '/photos/mirror.jpg', photoAlt: 'Nikita wearing headphones in a mirror', details: 'I studied cello for 8 years. I play guitar and used to play in a band. I also enjoy playing volleyball.' },
      ],
    },
  },
}

const t = computed(() => content[language.value])
const currentMusic = computed(() => t.value.music.items[activeMusic.value])
const currentFilm = computed(() => t.value.films.items[activeFilm.value])

function textColorFor(background) {
  const channels = background.slice(1).match(/.{2}/g).map((channel) => {
    const value = parseInt(channel, 16) / 255
    return value <= .04045 ? value / 12.92 : ((value + .055) / 1.055) ** 2.4
  })
  const luminance = channels[0] * .2126 + channels[1] * .7152 + channels[2] * .0722
  return luminance < .2 ? '#fff' : '#111111'
}

function isLightColor(background) {
  if (!background?.startsWith('#')) return false
  const channels = background.slice(1).match(/.{2}/g).map((channel) => {
    const value = parseInt(channel, 16) / 255
    return value <= .04045 ? value / 12.92 : ((value + .055) / 1.055) ** 2.4
  })
  return channels[0] * .2126 + channels[1] * .7152 + channels[2] * .0722 > .55
}

const currentMusicInk = computed(() => textColorFor(currentMusic.value.color))
const currentFilmInk = computed(() => textColorFor(currentFilm.value.color))

watchEffect(() => {
  const color = view.value === 'music'
    ? currentMusic.value.color
    : view.value === 'films'
      ? currentFilm.value.color
      : '#ffffff'
  document.documentElement.style.setProperty('--page-surface', color)
  document.querySelector('meta[name="theme-color"]')?.setAttribute('content', color)
})

function formatRouteNumber(value) {
  return new Intl.NumberFormat(language.value === 'sk' ? 'sk-SK' : 'en-US', {
    minimumFractionDigits: 1,
    maximumFractionDigits: 1,
  }).format(value)
}

function routeDistance(route) {
  return formatRouteNumber(route.distanceMi * 1.609344)
}

function routeSpeed(route) {
  return formatRouteNumber(route.distanceMi * 1.609344 * 60 / route.durationMinutes)
}

function routeDuration(route) {
  return `${Math.floor(route.durationMinutes / 60)} h ${route.durationMinutes % 60} min`
}

function routeNumber(index) {
  return String(index + 1).padStart(2, '0')
}

function routeLabel(route, index) {
  const places = route.places?.[language.value]
  if (Array.isArray(places)) return places.join(' ')
  return places || `${t.value.hobbies.route} ${routeNumber(index)}`
}

function routePlaces(route) {
  const places = route.places?.[language.value]
  return Array.isArray(places) ? places : null
}

function setLanguage(value) {
  language.value = value
  document.documentElement.lang = value
  localStorage.setItem('profile-language', value)
}

function restoreViewPosition(targetView, overrideTop = null) {
  nextTick(() => requestAnimationFrame(() => {
    window.scrollTo({ top: overrideTop ?? scrollPositions[targetView] ?? 0, behavior: 'instant' })
    if (targetView === 'home' && topicsGrid.value) topicsGrid.value.scrollTo({ left: topicScrollLeft.value, behavior: 'instant' })
    updateScrollCue()
  }))
}

function readHash() {
  const hash = location.hash.slice(1)
  const routeMatch = /^route-(\d+)$/.exec(hash)
  const previousView = view.value
  if (routeMatch && Number(routeMatch[1]) >= 1 && Number(routeMatch[1]) <= cyclingRoutes.length) {
    activeRoute.value = Number(routeMatch[1]) - 1
    activeHobby.value = 2
    view.value = 'routes'
  } else if (hash === 'routes') {
    activeHobby.value = 2
    view.value = 'routes'
  } else {
    view.value = ['music', 'films', 'hobbies'].includes(hash) ? hash : 'home'
  }
  if (previousView !== view.value) {
    const mobileRoutesBack = previousView === 'routes' && view.value === 'hobbies' && matchMedia('(max-width: 620px)').matches
    restoreViewPosition(view.value, mobileRoutesBack ? 0 : null)
  }
}

function openView(value) {
  scrollPositions[view.value] = window.scrollY
  if (view.value === 'home' && topicsGrid.value) topicScrollLeft.value = topicsGrid.value.scrollLeft
  location.hash = value
}

function goHome() {
  scrollPositions[view.value] = window.scrollY
  history.pushState(null, '', location.pathname + location.search)
  view.value = 'home'
  restoreViewPosition('home')
}

function goBack() {
  if (view.value === 'routes') {
    scrollPositions.routes = window.scrollY
    location.hash = 'hobbies'
  } else {
    goHome()
  }
}

function openRoutes() {
  scrollPositions.hobbies = window.scrollY
  location.hash = 'routes'
}

function moveRoute(direction) {
  activeRoute.value = (activeRoute.value + direction + cyclingRoutes.length) % cyclingRoutes.length
  location.hash = `route-${activeRoute.value + 1}`
}

function updateScrollCue() {
  const topics = document.getElementById('topics')
  if (!topics) return
  const y = Math.max(0, window.scrollY)
  const remaining = document.documentElement.scrollHeight - window.innerHeight - y
  if (y < 8) scrollCueUp.value = false
  else if (remaining < 8) scrollCueUp.value = true
  else if (y > scrollIntentAnchorY + 6) scrollCueUp.value = false
  else if (y < scrollIntentAnchorY - 6) scrollCueUp.value = true
  if (Math.abs(y - scrollIntentAnchorY) > 6 || y < 8 || remaining < 8) scrollIntentAnchorY = y
}

function updateTopicPosition(event) {
  const grid = event.target
  topicScrollLeft.value = grid.scrollLeft
  const card = grid.querySelector('.topic-card')
  if (!card) return
  const step = card.getBoundingClientRect().width + parseFloat(getComputedStyle(grid).gap || 0)
  activeTopic.value = Math.max(0, Math.min(2, Math.round(grid.scrollLeft / step)))
}

function scrollToTopic(index) {
  const grid = topicsGrid.value
  const card = grid?.querySelector('.topic-card')
  if (!card) return
  const step = card.getBoundingClientRect().width + parseFloat(getComputedStyle(grid).gap || 0)
  grid.scrollTo({ left: index * step, behavior: 'smooth' })
}

function scrollPage() {
  if (scrollCueUp.value) {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  } else {
    const next = [...document.querySelectorAll('.facts, .topics')].find((section) => section.offsetTop > window.scrollY + 24)
    if (next) next.scrollIntoView({ behavior: 'smooth', block: 'start' })
    else window.scrollTo({ top: document.documentElement.scrollHeight, behavior: 'smooth' })
  }
}

function contact() {
  contactOpen.value = true
  document.body.classList.add('modal-open')
  nextTick(() => socialModal.value?.querySelector('.modal-close')?.focus())
}

function closeContact() {
  contactOpen.value = false
  document.body.classList.remove('modal-open')
}

function onGlobalKeydown(event) {
  if (event.key === 'Escape' && contactOpen.value) closeContact()
}

function moveFilm(direction) {
  const length = t.value.films.items.length
  activeFilm.value = (activeFilm.value + direction + length) % length
}

function photoPosition(index) {
  if (index === activePhoto.value) return 'active'
  const difference = (index - activePhoto.value + photos.length) % photos.length
  return difference === 1 ? 'behind-right' : 'behind-left'
}

function startSwipe(event, type) {
  if (event.pointerType === 'mouse' && event.button !== 0) return
  event.preventDefault()
  window.getSelection()?.removeAllRanges()
  swipeStart.value = event.clientX
  swipeType.value = type
  swipePointer.value = event.pointerId
  dragX.value = 0
  event.currentTarget.setPointerCapture?.(event.pointerId)
}

function updateSwipe(event) {
  if (swipeStart.value === null || event.pointerId !== swipePointer.value) return
  dragX.value = Math.max(-140, Math.min(140, event.clientX - swipeStart.value))
}

function cancelSwipe() {
  swipeStart.value = null
  swipeType.value = null
  swipePointer.value = null
  dragX.value = 0
  window.getSelection()?.removeAllRanges()
}

function finishSwipe(event) {
  if (swipeStart.value === null || event.pointerId !== swipePointer.value) return
  const distance = event.clientX - swipeStart.value
  const type = swipeType.value
  cancelSwipe()
  if (Math.abs(distance) <= 40) return

  const direction = distance < 0 ? 1 : -1
  if (type === 'photos') activePhoto.value = (activePhoto.value + direction + photos.length) % photos.length
  else if (type === 'routes') moveRoute(direction)
  else moveInterest(type, direction)
}

function moveInterest(type, direction) {
  if (type === 'music') activeMusic.value = (activeMusic.value + direction + t.value.music.items.length) % t.value.music.items.length
  if (type === 'films') moveFilm(direction)
  if (type === 'hobbies') activeHobby.value = (activeHobby.value + direction + t.value.hobbies.items.length) % t.value.hobbies.items.length
}

onMounted(() => {
  history.scrollRestoration = 'manual'
  const saved = localStorage.getItem('profile-language')
  if (['sk', 'en'].includes(saved)) setLanguage(saved)
  readHash()
  addEventListener('hashchange', readHash)
  addEventListener('scroll', updateScrollCue, { passive: true })
  addEventListener('resize', updateScrollCue)
  addEventListener('keydown', onGlobalKeydown)
})

onUnmounted(() => {
  removeEventListener('hashchange', readHash)
  removeEventListener('scroll', updateScrollCue)
  removeEventListener('resize', updateScrollCue)
  removeEventListener('keydown', onGlobalKeydown)
  document.body.classList.remove('modal-open')
})
</script>

<template>
  <div class="app">
    <header class="topbar container" :class="{ 'inner-topbar': view !== 'home', 'home-topbar': view === 'home', 'color-topbar': view === 'music' || view === 'films' }" :style="view === 'music' ? { '--active': currentMusic.color, '--page-ink': currentMusicInk } : view === 'films' ? { '--active': currentFilm.color, '--page-ink': currentFilmInk } : undefined">
      <button v-if="view === 'home'" class="logo" aria-label="Home" @click="goHome">N<span>.</span></button>
      <button v-else class="back-button" @click="goBack"><ArrowLeft :size="18" aria-hidden="true" />{{ t.back }}</button>
      <div class="language-picker">
        <button :class="{ active: language === 'sk' }" @click="setLanguage('sk')">SK</button>
        <i>/</i>
        <button :class="{ active: language === 'en' }" @click="setLanguage('en')">EN</button>
      </div>
    </header>

    <main v-if="view === 'home'" class="home-page">
      <section class="profile container">
        <div class="profile-copy">
          <h1 class="profile-title">
            <span class="profile-hello">{{ t.titleHello }}</span>
            <span class="profile-name">{{ t.titleName }}</span>
          </h1>
          <div class="profile-actions">
            <button class="contact-button" @click="contact">
              <i class="message-icon" aria-hidden="true"><MessageCircleMore :size="22" :stroke-width="2" /></i>
              <span>{{ t.contact }}</span>
            </button>
          </div>
        </div>

        <div class="photo-carousel" :class="{ 'is-dragging': swipeType === 'photos' }" :style="{ '--drag-x': swipeType === 'photos' ? `${dragX}px` : '0px' }" aria-label="Photo carousel" @pointerdown="startSwipe($event, 'photos')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
          <div v-for="(photo, index) in photos" :key="photo.src" class="photo-card" :class="[photo.tone, photoPosition(index)]">
            <img :src="photo.src" :alt="photo.alt" draggable="false">
          </div>
          <div class="photo-dots"><button v-for="(_, index) in photos" :key="index" :class="{ active: index === activePhoto }" :aria-label="`Photo ${index + 1}`" @pointerdown.stop @click.stop="activePhoto = index"></button></div>
        </div>
        <button class="scroll-cue" :class="{ 'is-up': scrollCueUp }" :aria-label="scrollCueUp ? t.scrollTop : t.scrollDown" @click="scrollPage">
          <ArrowUp v-if="scrollCueUp" :size="26" aria-hidden="true" />
          <ArrowDown v-else :size="26" aria-hidden="true" />
        </button>
      </section>

      <section class="facts container" :aria-label="t.facts.title">
        <div class="facts-heading"><h2>{{ t.facts.title }}</h2></div>
        <div class="facts-grid">
          <div v-for="(question, index) in t.facts.questions" :key="index" class="fact-note" :class="{ 'is-open': revealedFacts[index] }" @click="revealedFacts[index] = true">
            <i class="note-magnet" aria-hidden="true"></i>
            <h3>{{ question[0] }}</h3>
            <button type="button" class="fact-reveal" :class="{ 'is-revealed': revealedFacts[index] }" :disabled="question[3] === null" :aria-label="`${question[0]} ${revealedFacts[index] ? question[question[3]] : language === 'sk' ? 'odkryť odpoveď' : 'reveal answer'}`" :aria-pressed="revealedFacts[index]" @click="revealedFacts[index] = true">
              <span class="fact-answer" :class="{ 'is-hidden': !revealedFacts[index] }">{{ question[question[3]] }}</span>
              <span class="fact-sparkles" aria-hidden="true">{{ question[question[3]] }}</span>
            </button>
          </div>
        </div>
      </section>

      <section id="topics" class="topics container">
        <div class="topic-heading"><h2>{{ t.explore }}</h2></div>

        <div class="topic-grid" ref="topicsGrid" @scroll="updateTopicPosition">
          <button v-for="name in ['hobbies', 'music', 'films']" :key="name" class="topic-card" :class="`topic-${name}`" @click="openView(name)">
            <ArrowUpRight class="topic-open-icon" :size="22" aria-hidden="true" />
            <component :is="topicIcons[name]" class="topic-icon" :size="110" :stroke-width="1.5" aria-hidden="true" />
            <h3>{{ t.menu[name].title }}</h3>
          </button>
        </div>
        <div class="topic-swipe-cue" :aria-label="t.explore"><button v-for="(name, index) in ['hobbies', 'music', 'films']" :key="name" type="button" :class="{ active: index === activeTopic }" :aria-label="t.menu[name].title" :aria-current="index === activeTopic ? 'true' : undefined" @click="scrollToTopic(index)"></button></div>
      </section>
    </main>

    <main v-else-if="view === 'music'" class="wrapped-page music-page" :style="{ '--active': currentMusic.color, '--page-ink': currentMusicInk }">
      <div class="container inner-page">
        <div class="wrapped-heading"><h1>{{ t.music.title }}</h1></div>
        <div class="interest-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'music' }" :style="{ '--drag-x': swipeType === 'music' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'music')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <div v-for="(item, index) in t.music.items" :key="index" class="interest-card music-interest-card" :class="{ 'is-active': index === activeMusic, 'is-near': (index - activeMusic + t.music.items.length) % t.music.items.length <= 2 }" :style="{ '--card-color': item.color, '--card-offset': `${(index - activeMusic + t.music.items.length) % t.music.items.length}` }">
              <span class="card-index">0{{ index + 1 }}</span><img :src="item.cover" :alt="`${item.title} — ${item.artist}`" draggable="false" @error="$event.currentTarget.style.display = 'none'">
            </div>
            <div class="swipe-indicator" aria-hidden="true"><i v-for="(_, index) in t.music.items" :key="index" :class="{ active: index === activeMusic }"></i></div>
          </div>
          <div class="interest-copy">
            <div class="interest-title-slot"><h2 :key="activeMusic">{{ currentMusic.title }}</h2></div>
            <div class="interest-meta-slot"><p :key="activeMusic">{{ currentMusic.artist }}</p></div>
            <div class="card-controls"><button :aria-label="t.previous" @click="moveInterest('music', -1)"><ArrowLeft :size="21" aria-hidden="true" /></button><button :aria-label="t.next" @click="moveInterest('music', 1)"><ArrowRight :size="21" aria-hidden="true" /></button></div>
          </div>
        </div>
      </div>
    </main>

    <main v-else-if="view === 'films'" class="wrapped-page films-page" :style="{ '--active': currentFilm.color, '--page-ink': currentFilmInk }">
      <div class="container inner-page">
        <div class="wrapped-heading"><h1>{{ t.films.title }}</h1></div>
        <div class="interest-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'films' }" :style="{ '--drag-x': swipeType === 'films' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'films')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <div v-for="(item, index) in t.films.items" :key="index" class="interest-card film-interest-card" :class="{ 'is-active': index === activeFilm, 'is-near': (index - activeFilm + t.films.items.length) % t.films.items.length <= 2 }" :style="{ '--card-color': item.color, '--card-offset': `${(index - activeFilm + t.films.items.length) % t.films.items.length}` }">
              <span class="card-index">0{{ index + 1 }}</span>
              <img :src="item.cover" :alt="item.title" draggable="false" @error="$event.currentTarget.style.display = 'none'">
              <b>{{ item.type }}</b>
            </div>
            <div class="swipe-indicator" aria-hidden="true"><i v-for="(_, index) in t.films.items" :key="index" :class="{ active: index === activeFilm }"></i></div>
          </div>
          <div class="interest-copy">
            <div class="interest-title-slot"><h2 :key="activeFilm">{{ currentFilm.title }}</h2></div>
            <div class="interest-meta-slot"><p :key="activeFilm">{{ currentFilm.year }}</p></div>
            <div class="card-controls"><button :aria-label="t.previous" @click="moveInterest('films', -1)"><ArrowLeft :size="21" aria-hidden="true" /></button><button :aria-label="t.next" @click="moveInterest('films', 1)"><ArrowRight :size="21" aria-hidden="true" /></button></div>
          </div>
        </div>
      </div>
    </main>

    <main v-else-if="view === 'hobbies'" class="wrapped-page hobbies-page">
      <div class="container inner-page">
        <div class="wrapped-heading"><h1>{{ t.hobbies.title }}</h1></div>
        <div class="interest-layout hobbies-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'hobbies' }" :style="{ '--drag-x': swipeType === 'hobbies' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'hobbies')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <article
              v-for="(item, index) in t.hobbies.items"
              :key="index"
              class="interest-card hobby-interest-card"
              :class="{ 'is-active': index === activeHobby, 'is-near': (index - activeHobby + t.hobbies.items.length) % t.hobbies.items.length <= 2, 'is-light': isLightColor(item.color) }"
              :style="{ '--card-color': item.color, '--card-offset': `${(index - activeHobby + t.hobbies.items.length) % t.hobbies.items.length}` }"
            >
              <img v-if="item.photo && index === activeHobby" class="hobby-photo" :class="{ 'photo-inverted': item.photo === '/photos/mirror.jpg' }" :src="item.photo" :alt="item.photoAlt" loading="lazy" draggable="false">
              <component :is="hobbyIcons[index]" class="hobby-symbol" :size="112" :stroke-width="1.5" aria-hidden="true" />
              <h2>{{ item.title }}</h2>
            </article>
            <div class="swipe-indicator" aria-hidden="true"><i v-for="(_, index) in t.hobbies.items" :key="index" :class="{ active: index === activeHobby }"></i></div>
          </div>
          <div class="interest-copy">
            <div class="interest-title-slot"><h2 :key="activeHobby">{{ t.hobbies.items[activeHobby].title }}</h2></div>
            <div class="interest-meta-slot"><p :key="activeHobby">{{ t.hobbies.items[activeHobby].details }}</p></div>
            <button v-if="activeHobby === 2" class="routes-cta" type="button" @click="openRoutes"><Map :size="20" aria-hidden="true" /><span>{{ t.hobbies.openRoute }}</span></button>
            <div class="card-controls"><button :aria-label="t.previous" @click="moveInterest('hobbies', -1)"><ArrowLeft :size="21" aria-hidden="true" /></button><button :aria-label="t.next" @click="moveInterest('hobbies', 1)"><ArrowRight :size="21" aria-hidden="true" /></button></div>
          </div>
        </div>
      </div>
    </main>

    <main v-else class="wrapped-page route-page">
      <div class="container inner-page">
        <div class="wrapped-heading"><h1>{{ t.hobbies.routes }}</h1></div>
        <div class="route-carousel-layout">
          <div class="route-stack" :class="{ 'is-dragging': swipeType === 'routes' }" :style="{ '--drag-x': swipeType === 'routes' ? `${dragX}px` : '0px' }" tabindex="0" :aria-label="t.hobbies.routes" @pointerdown="startSwipe($event, 'routes')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe" @keydown.left.prevent="moveRoute(-1)" @keydown.right.prevent="moveRoute(1)">
            <article v-for="(route, index) in cyclingRoutes" :key="route.src" class="interest-card route-interest-card" :class="{ 'is-active': index === activeRoute, 'is-near': (index - activeRoute + cyclingRoutes.length) % cyclingRoutes.length <= 2 }" :style="{ '--card-offset': `${(index - activeRoute + cyclingRoutes.length) % cyclingRoutes.length}` }">
              <img v-if="(index - activeRoute + cyclingRoutes.length) % cyclingRoutes.length <= 2" :src="route.src" :alt="`${routeLabel(route, index)} — ${routeDistance(route)} km`" draggable="false">
            </article>
            <div class="swipe-indicator" aria-hidden="true"><i v-for="(_, index) in cyclingRoutes" :key="index" :class="{ active: index === activeRoute }"></i></div>
          </div>
          <div class="route-carousel-copy">
            <h2 :key="activeRoute" class="route-title">
              <template v-if="routePlaces(cyclingRoutes[activeRoute])">
                <span>{{ routePlaces(cyclingRoutes[activeRoute])[0] }}</span>
                <ArrowLeftRight v-if="cyclingRoutes[activeRoute].roundTrip" class="route-dir-icon" aria-hidden="true" />
                <ArrowRight v-else class="route-dir-icon" aria-hidden="true" />
                <span>{{ routePlaces(cyclingRoutes[activeRoute])[1] }}</span>
              </template>
              <span v-else>{{ routeLabel(cyclingRoutes[activeRoute], activeRoute) }}</span>
            </h2>
            <div class="route-metrics">
              <div><span>{{ t.hobbies.distance }}</span><strong>{{ routeDistance(cyclingRoutes[activeRoute]) }} km</strong></div>
              <div><span>{{ t.hobbies.duration }}</span><strong>{{ routeDuration(cyclingRoutes[activeRoute]) }}</strong></div>
              <div><span>{{ t.hobbies.speed }}</span><strong>≈ {{ routeSpeed(cyclingRoutes[activeRoute]) }} km/h</strong></div>
            </div>
            <div class="card-controls"><button :aria-label="t.previous" @click="moveRoute(-1)"><ArrowLeft :size="21" aria-hidden="true" /></button><button :aria-label="t.next" @click="moveRoute(1)"><ArrowRight :size="21" aria-hidden="true" /></button></div>
          </div>
        </div>
      </div>
    </main>

    <div v-if="contactOpen" class="modal-backdrop" @click.self="closeContact">
      <section ref="socialModal" class="social-modal" role="dialog" aria-modal="true" :aria-label="t.socialTitle" @keydown.esc="closeContact">
        <button class="modal-close" :aria-label="t.back" @click="closeContact"><X :size="20" aria-hidden="true" /></button>
        <h2>{{ t.socialTitle }}</h2>
        <a v-for="social in t.socials" :key="social.label" :href="social.href" :target="social.href.startsWith('http') ? '_blank' : undefined" :rel="social.href.startsWith('http') ? 'noopener noreferrer' : undefined">
          <span class="social-label">
            <i class="social-icon" :style="{ color: brandIcons[social.icon].color }" aria-hidden="true">
              <img
                v-if="brandIcons[social.icon].slug"
                :src="`https://cdn.simpleicons.org/${brandIcons[social.icon].slug}`"
                width="22"
                height="22"
                alt=""
                draggable="false"
              >
              <svg v-else width="22" height="22" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4-8 5-8-5V6l8 5 8-5v2z"/></svg>
            </i>
            <span class="social-name">{{ social.label }}</span>
          </span>
          <span class="social-value">{{ social.value }}</span>
        </a>
      </section>
    </div>

  </div>
</template>
