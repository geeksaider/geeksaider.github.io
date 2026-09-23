<script setup>
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import { ArrowDown, ArrowLeft, ArrowRight, ArrowUp, ArrowUpRight, Bike, BriefcaseBusiness, ChevronDown, Clapperboard, CodeXml, ExternalLink, Mail, MessageCircleMore, Music2, Shapes, X } from '@lucide/vue'

const topicIcons = { music: Music2, films: Clapperboard, hobbies: Shapes }
const hobbyIcons = [BriefcaseBusiness, CodeXml, Bike, Music2]

const language = ref('sk')
const view = ref('home')
const activeMusic = ref(0)
const activeFilm = ref(0)
const activePhoto = ref(0)
const activeHobby = ref(0)
const activeRoute = ref(0)
const routesExpanded = ref(true)
const routesDetails = ref(null)
const revealedFacts = ref(Array(10).fill(false))
const swipeStart = ref(null)
const swipeType = ref(null)
const swipePointer = ref(null)
const dragX = ref(0)
const contactOpen = ref(false)
const atPageEnd = ref(false)

const photos = [
  { src: '/photos/cycling-stats.jpg', tone: 'photo-one', alt: 'Nikita v meste' },
  { src: '/photos/camera.jpg', tone: 'photo-two', alt: 'Nikita so slúchadlami' },
  { src: '/photos/mirror.jpg', tone: 'photo-three', alt: 'Nikita v zrkadle' },
  { src: '/photos/water.jpg', tone: 'photo-four', alt: 'Nikita pri graffiti' },
  { src: '/photos/hobby-cycling.jpg', tone: 'photo-five', alt: 'Nikita pri bicykli' },
]

const cyclingRoutes = [
  { src: '/photos/routes/IMG_8948.JPG', distanceMi: 59.3, durationMinutes: 317 },
  { src: '/photos/routes/IMG_8943.JPG', distanceMi: 57.4, durationMinutes: 286 },
  { src: '/photos/routes/IMG_8949.JPG', distanceMi: 56.95, durationMinutes: 334 },
  { src: '/photos/routes/IMG_8950.JPG', distanceMi: 45.8, durationMinutes: 396 },
  { src: '/photos/routes/IMG_8944.JPG', distanceMi: 40.5, durationMinutes: 202, places: { sk: 'Trnava ↔ Bratislava', en: 'Trnava ↔ Bratislava' } },
  { src: '/photos/routes/IMG_8945.PNG', distanceMi: 38.9, durationMinutes: 265 },
  { src: '/photos/routes/IMG_8953.JPG', distanceMi: 37.11, durationMinutes: 437, places: { sk: 'Moskva ↔ Chimki', en: 'Moscow ↔ Khimki' } },
  { src: '/photos/routes/IMG_8951.JPG', distanceMi: 29.54, durationMinutes: 195 },
  { src: '/photos/routes/IMG_8946.PNG', distanceMi: 18, durationMinutes: 104 },
  { src: '/photos/routes/IMG_8952.JPG', distanceMi: 11.15, durationMinutes: 96 },
]

const content = {
  sk: {
    title: 'Nikita',
    explore: 'vybrať tému',
    scrollTop: 'späť na začiatok',
    contact: 'napísať mi',
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
    socials: [{ label: 'Instagram', value: '@geeksaider', href: 'https://instagram.com/geeksaider' }, { label: 'Telegram', value: '@geeksaider', href: 'https://t.me/geeksaider' }, { label: 'E-mail', value: 'geeksaider@gmail.com', href: 'mailto:geeksaider@gmail.com' }],
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
      speedNote: 'orientačne podľa vzdialenosti a času', swipeRoutes: 'potiahni pre ďalšiu trasu',
      previousRoute: 'predchádzajúca trasa', nextRoute: 'ďalšia trasa', closeRoute: 'zatvoriť podrobnosti',
      items: [
        { title: 'Práca', color: 'var(--acid)', photo: '/photos/hobby-work.jpg', photoAlt: 'Nikita v práci', details: 'Pracoval som na viacerých pozíciách, od kuchára až po systémového analytika.' },
        { title: 'Programovanie', color: 'var(--pink)', photo: '/photos/programming.jpg', photoAlt: 'Kód na obrazovke notebooku', details: 'Tvorím weby a digitálne produkty.' },
        { title: 'Cyklistika', color: 'var(--violet)', photo: '/photos/hobby-cycling.jpg', photoAlt: 'Nikita s bicyklom', details: 'Moja najdlhšia uložená trasa má 95,4 km.' },
        { title: 'Voľný čas', color: 'var(--blue)', photo: '/photos/mirror.jpg', photoAlt: 'Nikita so slúchadlami v zrkadle', details: '8 rokov som študoval hru na violončele. Hrám na gitare, kedysi som hral v kapele. Rád hrávam volejbal.' },
      ],
    },
  },
  en: {
    title: 'Nikita',
    explore: 'choose a topic', scrollTop: 'back to top', contact: 'message me', back: 'back', previous: 'previous card', next: 'next card',
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
    socials: [{ label: 'Instagram', value: '@geeksaider', href: 'https://instagram.com/geeksaider' }, { label: 'Telegram', value: '@geeksaider', href: 'https://t.me/geeksaider' }, { label: 'E-mail', value: 'geeksaider@gmail.com', href: 'mailto:geeksaider@gmail.com' }],
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
      speedNote: 'estimated from distance and time', swipeRoutes: 'swipe for the next route',
      previousRoute: 'previous route', nextRoute: 'next route', closeRoute: 'close route details',
      items: [
        { title: 'Work', color: 'var(--acid)', photo: '/photos/hobby-work.jpg', photoAlt: 'Nikita at work', details: 'I have worked in several roles, from cook to systems analyst.' },
        { title: 'Programming', color: 'var(--pink)', photo: '/photos/programming.jpg', photoAlt: 'Code on a laptop screen', details: 'I build websites and digital products.' },
        { title: 'Cycling', color: 'var(--violet)', photo: '/photos/hobby-cycling.jpg', photoAlt: 'Nikita with a bicycle', details: 'My longest saved ride is 95.4 km.' },
        { title: 'Free time', color: 'var(--blue)', photo: '/photos/mirror.jpg', photoAlt: 'Nikita wearing headphones in a mirror', details: 'I studied cello for 8 years. I play guitar and used to play in a band. I also enjoy playing volleyball.' },
      ],
    },
  },
}

const t = computed(() => content[language.value])
const currentMusic = computed(() => t.value.music.items[activeMusic.value])
const currentFilm = computed(() => t.value.films.items[activeFilm.value])

watch(activeHobby, (index) => {
  if (index === 2) routesExpanded.value = true
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
  return route.places?.[language.value] || `${t.value.hobbies.route} ${routeNumber(index)}`
}

function setLanguage(value) {
  language.value = value
  document.documentElement.lang = value
  localStorage.setItem('profile-language', value)
}

function readHash() {
  const hash = location.hash.slice(1)
  const routeMatch = /^route-(\d+)$/.exec(hash)
  const fromRoute = view.value === 'route'
  if (routeMatch && Number(routeMatch[1]) >= 1 && Number(routeMatch[1]) <= cyclingRoutes.length) {
    activeRoute.value = Number(routeMatch[1]) - 1
    activeHobby.value = 2
    view.value = 'route'
  } else {
    view.value = ['music', 'films', 'hobbies'].includes(hash) ? hash : 'home'
  }
  nextTick(() => {
    if (fromRoute && view.value === 'hobbies') {
      routesExpanded.value = true
      nextTick(() => routesDetails.value?.scrollIntoView({ block: 'start' }))
    } else {
      window.scrollTo(0, 0)
    }
    updateScrollCue()
  })
}

function openView(value) {
  location.hash = value
}

function goHome() {
  history.pushState(null, '', location.pathname + location.search)
  view.value = 'home'
  nextTick(() => {
    window.scrollTo(0, 0)
    updateScrollCue()
  })
}

function goBack() {
  if (view.value === 'route') {
    routesExpanded.value = true
    location.hash = 'hobbies'
  } else {
    goHome()
  }
}

function openRoute(index) {
  activeRoute.value = index
  routesExpanded.value = true
  location.hash = `route-${index + 1}`
}

function updateScrollCue() {
  const topics = document.getElementById('topics')
  if (!topics) {
    atPageEnd.value = false
    return
  }
  const viewportHeight = window.innerHeight
  const remainingScroll = document.documentElement.scrollHeight - viewportHeight - window.scrollY
  atPageEnd.value = window.scrollY > 32 && (
    topics.getBoundingClientRect().top <= viewportHeight * 0.45 ||
    remainingScroll <= Math.min(viewportHeight * 0.25, 140)
  )
}

function scrollPage() {
  if (atPageEnd.value) {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  } else {
    document.getElementById('topics')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}

function contact() {
  contactOpen.value = true
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
}

function finishSwipe(event) {
  if (swipeStart.value === null || event.pointerId !== swipePointer.value) return
  const distance = event.clientX - swipeStart.value
  const type = swipeType.value
  cancelSwipe()
  if (Math.abs(distance) <= 40) return

  const direction = distance < 0 ? 1 : -1
  if (type === 'photos') activePhoto.value = (activePhoto.value + direction + photos.length) % photos.length
  else moveInterest(type, direction)
}

function moveInterest(type, direction) {
  if (type === 'music') activeMusic.value = (activeMusic.value + direction + t.value.music.items.length) % t.value.music.items.length
  if (type === 'films') moveFilm(direction)
  if (type === 'hobbies') activeHobby.value = (activeHobby.value + direction + t.value.hobbies.items.length) % t.value.hobbies.items.length
}

onMounted(() => {
  const saved = localStorage.getItem('profile-language')
  if (['sk', 'en'].includes(saved)) setLanguage(saved)
  readHash()
  addEventListener('hashchange', readHash)
  addEventListener('scroll', updateScrollCue, { passive: true })
  addEventListener('resize', updateScrollCue)
})

onUnmounted(() => {
  removeEventListener('hashchange', readHash)
  removeEventListener('scroll', updateScrollCue)
  removeEventListener('resize', updateScrollCue)
})
</script>

<template>
  <div class="app">
    <header class="topbar container" :class="{ 'inner-topbar': view !== 'home', 'home-topbar': view === 'home' }">
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
          <h1>{{ t.title }}</h1>
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
        <button class="scroll-cue" :class="{ 'is-up': atPageEnd }" :aria-label="atPageEnd ? t.scrollTop : t.explore" @click="scrollPage">
          <ArrowUp v-if="atPageEnd" :size="26" aria-hidden="true" />
          <ArrowDown v-else :size="26" aria-hidden="true" />
        </button>
      </section>

      <section class="facts container" :aria-label="t.facts.title">
        <div class="facts-folder">
          <div class="facts-heading"><h2>{{ t.facts.title }}</h2><span>{{ language === 'sk' ? 'ťukni a odkry' : 'tap to reveal' }}</span></div>
          <div class="facts-grid">
            <div v-for="(question, index) in t.facts.questions" :key="index" class="fact-row">
              <h3>{{ question[0] }}</h3>
              <button type="button" class="fact-reveal" :class="{ 'is-revealed': revealedFacts[index] }" :disabled="question[3] === null" :aria-label="`${question[0]} ${revealedFacts[index] ? question[question[3]] : language === 'sk' ? 'odkryť odpoveď' : 'reveal answer'}`" :aria-pressed="revealedFacts[index]" @click="revealedFacts[index] = true">
                <span v-if="revealedFacts[index]">{{ question[question[3]] }}</span><span v-else aria-hidden="true">?</span>
              </button>
            </div>
          </div>
        </div>
      </section>

      <section id="topics" class="topics container">
        <div class="topic-heading"><h2>{{ t.explore }}</h2></div>

        <div class="topic-grid">
          <button v-for="name in ['music', 'films', 'hobbies']" :key="name" class="topic-card" :class="`topic-${name}`" @click="openView(name)">
            <ArrowUpRight class="topic-open-icon" :size="22" aria-hidden="true" />
            <component :is="topicIcons[name]" class="topic-icon" :size="110" :stroke-width="1.5" aria-hidden="true" />
            <h3>{{ t.menu[name].title }}</h3>
          </button>
        </div>
      </section>
    </main>

    <main v-else-if="view === 'music'" class="wrapped-page music-page" :style="{ '--active': currentMusic.color }">
      <div class="container inner-page">
        <div class="wrapped-heading"><h1>{{ t.music.title }}</h1></div>
        <div class="interest-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'music' }" :style="{ '--drag-x': swipeType === 'music' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'music')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <div v-for="(item, index) in t.music.items" :key="item.title" class="interest-card music-interest-card" :class="{ 'is-active': index === activeMusic }" :style="{ '--card-color': item.color, '--card-offset': `${(index - activeMusic + t.music.items.length) % t.music.items.length}` }">
              <span class="card-index">0{{ index + 1 }}</span><img :src="item.cover" :alt="`${item.title} — ${item.artist}`" draggable="false" @error="$event.currentTarget.style.display = 'none'">
            </div>
          </div>
          <div class="interest-copy">
            <div class="interest-title-slot"><h2 v-for="(item, index) in t.music.items" :key="item.title" :class="{ 'is-active': index === activeMusic }" :aria-hidden="index !== activeMusic">{{ item.title }}</h2></div>
            <div class="interest-meta-slot"><p v-for="(item, index) in t.music.items" :key="item.title" :class="{ 'is-active': index === activeMusic }" :aria-hidden="index !== activeMusic">{{ item.artist }}</p></div>
            <div class="card-controls"><button :aria-label="t.previous" @click="moveInterest('music', -1)"><ArrowLeft :size="21" aria-hidden="true" /></button><button :aria-label="t.next" @click="moveInterest('music', 1)"><ArrowRight :size="21" aria-hidden="true" /></button></div>
          </div>
        </div>
      </div>
    </main>

    <main v-else-if="view === 'films'" class="wrapped-page films-page" :style="{ '--active': currentFilm.color }">
      <div class="container inner-page">
        <div class="wrapped-heading"><h1>{{ t.films.title }}</h1></div>
        <div class="interest-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'films' }" :style="{ '--drag-x': swipeType === 'films' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'films')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <div v-for="(item, index) in t.films.items" :key="item.title" class="interest-card film-interest-card" :class="{ 'is-active': index === activeFilm }" :style="{ '--card-color': item.color, '--card-offset': `${(index - activeFilm + t.films.items.length) % t.films.items.length}` }">
              <span class="card-index">0{{ index + 1 }}</span>
              <img :src="item.cover" :alt="item.title" draggable="false" @error="$event.currentTarget.style.display = 'none'">
              <b>{{ item.type }}</b>
            </div>
          </div>
          <div class="interest-copy">
            <div class="interest-title-slot"><h2 v-for="(item, index) in t.films.items" :key="item.title" :class="{ 'is-active': index === activeFilm }" :aria-hidden="index !== activeFilm">{{ item.title }}</h2></div>
            <div class="interest-meta-slot"><p v-for="(item, index) in t.films.items" :key="item.title" :class="{ 'is-active': index === activeFilm }" :aria-hidden="index !== activeFilm">{{ item.year }}</p></div>
            <div class="card-controls"><button :aria-label="t.previous" @click="moveInterest('films', -1)"><ArrowLeft :size="21" aria-hidden="true" /></button><button :aria-label="t.next" @click="moveInterest('films', 1)"><ArrowRight :size="21" aria-hidden="true" /></button></div>
          </div>
        </div>
      </div>
    </main>

    <main v-else-if="view === 'hobbies'" class="wrapped-page hobbies-page">
      <div class="container inner-page">
        <div class="wrapped-heading"><h1>{{ t.hobbies.title }}</h1></div>
        <nav class="hobby-tabs" :aria-label="t.menu.hobbies.title">
          <button v-for="(item, index) in t.hobbies.items" :key="item.title" type="button" :class="{ active: index === activeHobby }" :aria-pressed="index === activeHobby" @click="activeHobby = index">{{ item.title }}</button>
        </nav>
        <div class="interest-layout hobbies-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'hobbies' }" :style="{ '--drag-x': swipeType === 'hobbies' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'hobbies')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <article
              v-for="(item, index) in t.hobbies.items"
              :key="item.title"
              class="interest-card hobby-interest-card"
              :class="{ 'is-active': index === activeHobby, 'is-light': /acid|pink|blue/.test(item.color) }"
              :style="{ '--card-color': item.color, '--card-offset': `${(index - activeHobby + t.hobbies.items.length) % t.hobbies.items.length}` }"
            >
              <img v-if="item.photo && index === activeHobby" class="hobby-photo" :class="{ 'photo-inverted': item.photo === '/photos/mirror.jpg' }" :src="item.photo" :alt="item.photoAlt" loading="lazy" draggable="false">
              <component :is="hobbyIcons[index]" class="hobby-symbol" :size="112" :stroke-width="1.5" aria-hidden="true" />
              <h2>{{ item.title }}</h2>
            </article>
          </div>
          <div class="hobby-side">
            <div class="interest-copy">
              <div class="interest-title-slot"><h2 v-for="(item, index) in t.hobbies.items" :key="item.title" :class="{ 'is-active': index === activeHobby }" :aria-hidden="index !== activeHobby">{{ item.title }}</h2></div>
              <div class="interest-meta-slot"><p v-for="(item, index) in t.hobbies.items" :key="item.title" class="hobby-details" :class="{ 'is-active': index === activeHobby }" :aria-hidden="index !== activeHobby">{{ item.details }}</p></div>
              <div class="card-controls"><button :aria-label="t.previous" @click="moveInterest('hobbies', -1)"><ArrowLeft :size="21" aria-hidden="true" /></button><button :aria-label="t.next" @click="moveInterest('hobbies', 1)"><ArrowRight :size="21" aria-hidden="true" /></button></div>
            </div>
            <details v-if="activeHobby === 2" ref="routesDetails" class="cycling-routes" :open="routesExpanded" @toggle="routesExpanded = $event.target.open">
              <summary><span>{{ t.hobbies.routes }} <small>10</small></span><ChevronDown :size="22" aria-hidden="true" /></summary>
              <div class="cycling-routes-list">
                <a v-for="(route, index) in cyclingRoutes" :key="route.src" class="cycling-route-link" :href="`#route-${index + 1}`" @click.prevent="openRoute(index)">
                  <span><small>{{ routeNumber(index) }}</small>{{ routeLabel(route, index) }}</span><strong>{{ routeDistance(route) }} km</strong><ArrowUpRight :size="18" aria-hidden="true" />
                </a>
              </div>
            </details>
          </div>
        </div>
      </div>
    </main>

    <main v-else class="wrapped-page route-page">
      <div class="container inner-page">
        <div class="route-page-heading">
          <small>{{ t.hobbies.route }} {{ routeNumber(activeRoute) }}</small>
          <h1>{{ routeLabel(cyclingRoutes[activeRoute], activeRoute) }}</h1>
        </div>
        <div class="route-page-stats">
          <div class="route-main-stat"><span>{{ t.hobbies.distance }}</span><strong>{{ routeDistance(cyclingRoutes[activeRoute]) }} <small>km</small></strong></div>
          <div><span>{{ t.hobbies.duration }}</span><strong>{{ routeDuration(cyclingRoutes[activeRoute]) }}</strong></div>
          <div><span>{{ t.hobbies.speed }}</span><strong>≈ {{ routeSpeed(cyclingRoutes[activeRoute]) }} km/h</strong></div>
        </div>
        <p class="route-speed-note">{{ t.hobbies.speedNote }}</p>
        <figure class="route-source"><img :src="cyclingRoutes[activeRoute].src" :alt="`${routeLabel(cyclingRoutes[activeRoute], activeRoute)} — ${routeDistance(cyclingRoutes[activeRoute])} km`"><figcaption>{{ language === 'sk' ? 'Pôvodný záznam trasy' : 'Original route record' }}</figcaption></figure>
        <nav class="route-page-nav" :aria-label="t.hobbies.routes">
          <a v-if="activeRoute > 0" :href="`#route-${activeRoute}`" @click.prevent="openRoute(activeRoute - 1)"><ArrowLeft :size="18" aria-hidden="true" /> {{ t.hobbies.previousRoute }}</a>
          <a v-if="activeRoute < cyclingRoutes.length - 1" :href="`#route-${activeRoute + 2}`" @click.prevent="openRoute(activeRoute + 1)">{{ t.hobbies.nextRoute }} <ArrowRight :size="18" aria-hidden="true" /></a>
        </nav>
      </div>
    </main>

    <div v-if="contactOpen" class="modal-backdrop" @click.self="contactOpen = false">
      <section class="social-modal" role="dialog" aria-modal="true" :aria-label="t.socialTitle">
        <button class="modal-close" :aria-label="t.back" @click="contactOpen = false"><X :size="20" aria-hidden="true" /></button>
        <h2>{{ t.socialTitle }}</h2>
        <a v-for="social in t.socials" :key="social.label" :href="social.href" :target="social.href.startsWith('http') ? '_blank' : undefined" :rel="social.href.startsWith('http') ? 'noopener noreferrer' : undefined">{{ social.label }} <span>{{ social.value }} <ExternalLink v-if="social.href.startsWith('http')" :size="14" aria-hidden="true" /><Mail v-else :size="14" aria-hidden="true" /></span></a>
      </section>
    </div>

  </div>
</template>
