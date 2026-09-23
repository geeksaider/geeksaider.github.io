<script setup>
import { computed, nextTick, onMounted, onUnmounted, ref } from 'vue'

const language = ref('sk')
const view = ref('home')
const activeMusic = ref(0)
const activeFilm = ref(0)
const activePhoto = ref(0)
const activeHobby = ref(0)
const revealedRows = ref(0)
const swipeStart = ref(null)
const swipeType = ref(null)
const swipePointer = ref(null)
const dragX = ref(0)
const contactOpen = ref(false)
const atPageEnd = ref(false)
const routeOpen = ref(false)
const activeRoute = ref(0)
const routeDialog = ref(null)
let routeTrigger = null

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
  { src: '/photos/routes/IMG_8944.JPG', distanceMi: 40.5, durationMinutes: 202 },
  { src: '/photos/routes/IMG_8945.PNG', distanceMi: 38.9, durationMinutes: 265 },
  { src: '/photos/routes/IMG_8953.JPG', distanceMi: 37.11, durationMinutes: 437 },
  { src: '/photos/routes/IMG_8951.JPG', distanceMi: 29.54, durationMinutes: 195 },
  { src: '/photos/routes/IMG_8946.PNG', distanceMi: 18, durationMinutes: 104 },
  { src: '/photos/routes/IMG_8952.JPG', distanceMi: 11.15, durationMinutes: 96 },
]

const content = {
  sk: {
    title: 'Nikita',
    meta: 'Spravil som web namiesto normálneho bio.',
    explore: 'vybrať tému',
    scrollTop: 'späť na začiatok',
    contact: 'napísať mi',
    back: 'späť',
    dossier: {
      label: 'záznam 001', title: 'Osobný spis', reveal: 'odkryť ďalší riadok', complete: 'spis odhalený', tap: 'odkryť', locked: 'zamknuté',
      rows: [
        ['Meno', 'Nikita'],
        ['Vek', '20'],
        ['Práca', 'áno'],
        ['Štúdium', 'Finančnú univerzitu som skončil, teraz MTF STU / PIAR'],
        ['Fajčenie', 'bohužiaľ áno'],
        ['Výška', '190 cm'],
        ['Znamenie', 'Váhy'],
      ],
    },
    socialTitle: 'nájdeme sa aj inde',
    socialHint: 'vyber sociálnu sieť',
    socials: [{ label: 'Instagram', value: '@geeksaider', href: 'https://instagram.com/geeksaider' }, { label: 'Telegram', value: '@geeksaider', href: 'https://t.me/geeksaider' }, { label: 'E-mail', value: 'geeksaider@gmail.com', href: 'mailto:geeksaider@gmail.com' }],
    menu: {
      music: { index: '01', title: 'Môj hudobný vkus', stat: 'TOP 5', label: 'najhranejšie' },
      films: { index: '02', title: 'Obľúbené filmy', stat: 'TOP 5', label: 'osobný výber' },
      hobbies: { index: '03', title: 'Hobby', stat: '04', label: 'hlavné záujmy' },
    },
    music: {
      kicker: 'moja hudba', title: 'Môj hudobný vkus', hint: 'potiahni alebo klikni', swipeHint: 'potiahni kartu',
      items: [
        { title: 'Baby One More Time', artist: 'Travis', color: '#cbbca4', cover: 'https://i.ebayimg.com/images/g/Y8QAAOSw7fBhFq8Y/s-l1200.jpg' },
        { title: 'I Smoked Away My Brain', artist: 'A$AP Rocky feat. Imogen Heap & Clams Casino', color: '#aaa9a6', cover: 'https://i.pinimg.com/736x/04/82/f9/0482f940e8df6a89ee541d50575e629f.jpg' },
        { title: 'Everyday', artist: 'A$AP Rocky feat. Rod Stewart, Miguel & Mark Ronson', color: '#d9d5ce', cover: '/photos/covers/everyday.jpg' },
        { title: 'Omen', artist: 'The Prodigy', color: '#ff6b49', cover: 'https://images.universal-music.de/img/assets/165/165942/4/1200/invaders-must-die-0602517955608.jpg' },
        { title: "It Can't Come Quickly Enough", artist: 'Scissor Sisters', color: '#67d9ff', cover: 'https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/36/38/45/363845a9-dc46-1605-dce3-f41b1b11e97d/25UMGIM38812.rgb.jpg/1200x630wp-60.jpg' },
      ],
    },
    films: {
      kicker: 'môj výber', title: 'Obľúbené filmy', hint: 'potiahni alebo klikni', swipeHint: 'potiahni kartu',
      items: [
        { title: 'Stávka na neistotu', year: '2015', type: 'FILM', color: '#7657ff', cover: '/photos/covers/big-short.jpg' },
        { title: 'Hlúpa láska', year: '2011', type: 'FILM', color: '#ffb2d0', cover: '/photos/covers/crazy-stupid-love.jpg' },
        { title: 'Teória veľkého tresku', year: '2007–2019', type: 'SERIÁL', color: '#e6ff42', cover: '/photos/covers/bbt.jpg' },
        { title: 'Ako som spoznal vašu matku', year: '2005–2014', type: 'SERIÁL', color: '#67d9ff', cover: '/photos/covers/himym.jpg' },
        { title: '10 vecí, ktoré na tebe neznášam', year: '1999', type: 'FILM', color: '#ff6b49', cover: '/photos/covers/10-things.jpg' },
      ],
    },
    hobbies: {
      kicker: 'mimo profilu', title: 'Čomu sa venujem',
      routes: 'Moje cyklotrasy', route: 'Cyklotrasa', openRoute: 'Podrobnosti',
      distance: 'vzdialenosť', duration: 'čas', speed: 'priemerná rýchlosť',
      speedNote: 'orientačne podľa vzdialenosti a času', swipeRoutes: 'potiahni pre ďalšiu trasu',
      previousRoute: 'predchádzajúca trasa', nextRoute: 'ďalšia trasa', closeRoute: 'zatvoriť podrobnosti',
      items: [
        { number: '01', title: 'Práca', symbol: '▣', color: 'var(--acid)', photo: '/photos/hobby-work.jpg', photoAlt: 'Nikita v práci', note: 'rôzne skúsenosti', details: 'Pracoval som na viacerých pozíciách, od kuchára až po systémového analytika.' },
        { number: '02', title: 'Programovanie', symbol: '</>', color: 'var(--pink)', photo: '/photos/programming.jpg', photoAlt: 'Kód na obrazovke notebooku', note: 'kód a produkty' },
        { number: '03', title: 'Cyklistika', symbol: '◎', color: 'var(--violet)', photo: '/photos/hobby-cycling.jpg', photoAlt: 'Nikita s bicyklom', note: 'dlhé trasy' },
        { number: '04', title: 'Voľný čas', symbol: '♪', color: 'var(--blue)', photo: '/photos/mirror.jpg', photoAlt: 'Nikita so slúchadlami v zrkadle', note: 'hudba a volejbal', details: '8 rokov som študoval hru na violončele. Hrám na gitare, kedysi som hral v kapele. Rád hrávam volejbal.' },
      ],
    },
    footer: 'koniec profilu',
  },
  en: {
    title: 'Nikita',
    meta: 'I built a website instead of writing a normal bio.',
    explore: 'choose a topic', scrollTop: 'back to top', contact: 'message me', back: 'back',
    dossier: {
      label: 'record 001', title: 'Personal file', reveal: 'reveal next line', complete: 'file revealed', tap: 'reveal', locked: 'locked',
      rows: [
        ['Name', 'Nikita'],
        ['Age', '20'],
        ['Work', 'yes'],
        ['Studies', 'Finished Financial University, now MTF STU / PIAR'],
        ['Smoking', 'unfortunately, yes'],
        ['Height', '190 cm'],
        ['Zodiac', 'Libra'],
      ],
    },
    socialTitle: 'find me elsewhere',
    socialHint: 'choose a social network',
    socials: [{ label: 'Instagram', value: '@geeksaider', href: 'https://instagram.com/geeksaider' }, { label: 'Telegram', value: '@geeksaider', href: 'https://t.me/geeksaider' }, { label: 'E-mail', value: 'geeksaider@gmail.com', href: 'mailto:geeksaider@gmail.com' }],
    menu: {
      music: { index: '01', title: 'My music taste', stat: 'TOP 5', label: 'most played' },
      films: { index: '02', title: 'Favorite films', stat: 'TOP 5', label: 'personal selection' },
      hobbies: { index: '03', title: 'Hobbies', stat: '04', label: 'main interests' },
    },
    music: {
      kicker: 'my music', title: 'My music taste', hint: 'swipe or click', swipeHint: 'swipe the card',
      items: [
        { title: 'Baby One More Time', artist: 'Travis', color: '#cbbca4', cover: 'https://i.ebayimg.com/images/g/Y8QAAOSw7fBhFq8Y/s-l1200.jpg' },
        { title: 'I Smoked Away My Brain', artist: 'A$AP Rocky feat. Imogen Heap & Clams Casino', color: '#aaa9a6', cover: 'https://i.pinimg.com/736x/04/82/f9/0482f940e8df6a89ee541d50575e629f.jpg' },
        { title: 'Everyday', artist: 'A$AP Rocky feat. Rod Stewart, Miguel & Mark Ronson', color: '#d9d5ce', cover: '/photos/covers/everyday.jpg' },
        { title: 'Omen', artist: 'The Prodigy', color: '#ff6b49', cover: 'https://images.universal-music.de/img/assets/165/165942/4/1200/invaders-must-die-0602517955608.jpg' },
        { title: "It Can't Come Quickly Enough", artist: 'Scissor Sisters', color: '#67d9ff', cover: 'https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/36/38/45/363845a9-dc46-1605-dce3-f41b1b11e97d/25UMGIM38812.rgb.jpg/1200x630wp-60.jpg' },
      ],
    },
    films: {
      kicker: 'my selection', title: 'Favorite films', hint: 'swipe or click', swipeHint: 'swipe the card',
      items: [
        { title: 'The Big Short', year: '2015', type: 'FILM', color: '#7657ff', cover: '/photos/covers/big-short.jpg' },
        { title: 'Crazy, Stupid, Love', year: '2011', type: 'FILM', color: '#ffb2d0', cover: '/photos/covers/crazy-stupid-love.jpg' },
        { title: 'The Big Bang Theory', year: '2007–2019', type: 'SERIES', color: '#e6ff42', cover: '/photos/covers/bbt.jpg' },
        { title: 'How I Met Your Mother', year: '2005–2014', type: 'SERIES', color: '#67d9ff', cover: '/photos/covers/himym.jpg' },
        { title: '10 Things I Hate About You', year: '1999', type: 'FILM', color: '#ff6b49', cover: '/photos/covers/10-things.jpg' },
      ],
    },
    hobbies: {
      kicker: 'beyond the profile', title: 'What I spend time on',
      routes: 'My cycling routes', route: 'Cycling route', openRoute: 'Details',
      distance: 'distance', duration: 'time', speed: 'average speed',
      speedNote: 'estimated from distance and time', swipeRoutes: 'swipe for the next route',
      previousRoute: 'previous route', nextRoute: 'next route', closeRoute: 'close route details',
      items: [
        { number: '01', title: 'Work', symbol: '▣', color: 'var(--acid)', photo: '/photos/hobby-work.jpg', photoAlt: 'Nikita at work', note: 'different roles', details: 'I have worked in several roles, from cook to systems analyst.' },
        { number: '02', title: 'Programming', symbol: '</>', color: 'var(--pink)', photo: '/photos/programming.jpg', photoAlt: 'Code on a laptop screen', note: 'code & products' },
        { number: '03', title: 'Cycling', symbol: '◎', color: 'var(--violet)', photo: '/photos/hobby-cycling.jpg', photoAlt: 'Nikita with a bicycle', note: 'long rides' },
        { number: '04', title: 'Free time', symbol: '♪', color: 'var(--blue)', photo: '/photos/mirror.jpg', photoAlt: 'Nikita wearing headphones in a mirror', note: 'music and volleyball', details: 'I studied cello for 8 years. I play guitar and used to play in a band. I also enjoy playing volleyball.' },
      ],
    },
    footer: 'end of profile',
  },
}

const t = computed(() => content[language.value])
const currentMusic = computed(() => t.value.music.items[activeMusic.value])
const currentFilm = computed(() => t.value.films.items[activeFilm.value])
const currentHobby = computed(() => t.value.hobbies.items[activeHobby.value])
const currentRoute = computed(() => cyclingRoutes[activeRoute.value])

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

function openRoute(index, event) {
  routeTrigger = event.currentTarget
  activeRoute.value = index
  routeOpen.value = true
  nextTick(() => routeDialog.value?.focus())
}

function closeRoute() {
  routeOpen.value = false
  cancelSwipe()
  nextTick(() => routeTrigger?.focus())
}

function setLanguage(value) {
  language.value = value
  document.documentElement.lang = value
  localStorage.setItem('profile-language', value)
}

function readHash() {
  if (routeOpen.value) closeRoute()
  const hash = location.hash.slice(1)
  view.value = ['music', 'films', 'hobbies'].includes(hash) ? hash : 'home'
  nextTick(() => {
    window.scrollTo(0, 0)
    updateScrollCue()
  })
}

function openView(value) {
  location.hash = value
}

function goHome() {
  if (routeOpen.value) closeRoute()
  history.pushState(null, '', location.pathname + location.search)
  view.value = 'home'
  nextTick(() => {
    window.scrollTo(0, 0)
    updateScrollCue()
  })
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

function revealRow(index) {
  if (index === revealedRows.value) revealedRows.value += 1
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
  if (type === 'routes') activeRoute.value = (activeRoute.value + direction + cyclingRoutes.length) % cyclingRoutes.length
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
    <header class="topbar container">
      <button class="logo" aria-label="Home" @click="goHome">N<span>.</span></button>
      <div class="language-picker">
        <button :class="{ active: language === 'sk' }" @click="setLanguage('sk')">SK</button>
        <i>/</i>
        <button :class="{ active: language === 'en' }" @click="setLanguage('en')">EN</button>
      </div>
    </header>

    <main v-if="view === 'home'">
      <section class="profile container">
        <div class="profile-copy">
          <h1>{{ t.title }}</h1>
          <p class="meta-line">{{ t.meta }}</p>
          <div class="profile-actions">
            <button class="contact-button" @click="contact">
              <i class="message-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><path d="M20 15a4 4 0 0 1-4 4H8l-5 3V7a4 4 0 0 1 4-4h9a4 4 0 0 1 4 4Z"/><path d="M8 10h.01M12 10h.01M16 10h.01"/></svg>
              </i>
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
          <span class="material-symbols-outlined" aria-hidden="true">{{ atPageEnd ? 'north' : 'south' }}</span>
        </button>
      </section>

      <section class="dossier container">
        <div class="dossier-top">
          <div><small>{{ t.dossier.label }}</small><h2>{{ t.dossier.title }}</h2></div>
          <span>{{ String(revealedRows).padStart(2, '0') }} / 0{{ t.dossier.rows.length }}</span>
        </div>
        <div class="dossier-lines">
          <button
            v-for="(row, index) in t.dossier.rows"
            :key="row[0]"
            :class="{ revealed: index < revealedRows, next: index === revealedRows }"
            @click="revealRow(index)"
          >
            <small>0{{ index + 1 }}</small><span>{{ row[0] }}</span><strong>{{ row[1] }}</strong>
            <em v-if="index === revealedRows" class="reveal-hint"><i></i>{{ t.dossier.tap }}</em>
            <em v-else-if="index > revealedRows" class="locked-hint">● {{ t.dossier.locked }}</em>
          </button>
        </div>
        <button class="reveal-button" :disabled="revealedRows === t.dossier.rows.length" @click="revealedRows++">
          {{ revealedRows === t.dossier.rows.length ? t.dossier.complete : t.dossier.reveal }}
          <span>{{ revealedRows === t.dossier.rows.length ? '✓' : '＋' }}</span>
        </button>
      </section>

      <section id="topics" class="topics container">
        <div class="topic-heading">
          <span>01—03</span>
          <h2>{{ t.explore }}</h2>
        </div>

        <div class="topic-grid">
          <button v-for="name in ['music', 'films', 'hobbies']" :key="name" class="topic-card" :class="`topic-${name}`" @click="openView(name)">
            <span class="topic-number">{{ t.menu[name].index }}</span>
            <strong>{{ t.menu[name].stat }}</strong>
            <h3>{{ t.menu[name].title }}</h3>
            <p>{{ t.menu[name].label }}</p>
            <div v-if="name === 'music'" class="mini-bars"><i v-for="n in 11" :key="n" :style="{ height: `${20 + ((n * 17) % 66)}%` }"></i></div>
            <div v-if="name === 'films'" class="mini-frame"><i></i><i></i><i></i></div>
            <div v-if="name === 'hobbies'" class="mini-orbit"><i></i><i></i></div>
          </button>
        </div>
      </section>
    </main>

    <main v-else-if="view === 'music'" class="wrapped-page music-page" :style="{ '--active': currentMusic.color }">
      <div class="container inner-page">
        <button class="back-button" @click="goHome">{{ t.back }}</button>
        <div class="wrapped-heading"><h1>{{ t.music.title }}</h1></div>
        <div class="interest-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'music' }" :style="{ '--drag-x': swipeType === 'music' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'music')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <div v-for="(item, index) in t.music.items" :key="item.title" class="interest-card music-interest-card" :class="{ 'is-active': index === activeMusic }" :style="{ '--card-color': item.color, '--card-offset': `${(index - activeMusic + t.music.items.length) % t.music.items.length}` }">
              <span class="card-index">0{{ index + 1 }}</span><img :src="item.cover" :alt="`${item.title} — ${item.artist}`" draggable="false" @error="$event.currentTarget.style.display = 'none'"><small>TOP TRACK</small>
            </div>
          </div>
          <div class="interest-copy"><small><span class="desktop-hint">{{ t.music.hint }}</span><span class="mobile-hint">{{ t.music.swipeHint }}</span></small><h2>{{ currentMusic.title }}</h2><p>{{ currentMusic.artist }}</p><div class="card-controls"><button @click="moveInterest('music', -1)">←</button><button @click="moveInterest('music', 1)">→</button></div></div>
        </div>
      </div>
    </main>

    <main v-else-if="view === 'films'" class="wrapped-page films-page" :style="{ '--active': currentFilm.color }">
      <div class="container inner-page">
        <button class="back-button" @click="goHome">{{ t.back }}</button>
        <div class="wrapped-heading"><h1>{{ t.films.title }}</h1></div>
        <div class="interest-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'films' }" :style="{ '--drag-x': swipeType === 'films' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'films')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <div v-for="(item, index) in t.films.items" :key="item.title" class="interest-card film-interest-card" :class="{ 'is-active': index === activeFilm }" :style="{ '--card-color': item.color, '--card-offset': `${(index - activeFilm + t.films.items.length) % t.films.items.length}` }">
              <span class="card-index">0{{ index + 1 }}</span>
              <img :src="item.cover" :alt="item.title" draggable="false" @error="$event.currentTarget.style.display = 'none'">
              <b>{{ item.type }}</b>
            </div>
          </div>
          <div class="interest-copy"><small><span class="desktop-hint">{{ t.films.hint }}</span><span class="mobile-hint">{{ t.films.swipeHint }}</span></small><h2>{{ currentFilm.title }}</h2><p>{{ currentFilm.year }}</p><div class="card-controls"><button @click="moveInterest('films', -1)">←</button><button @click="moveInterest('films', 1)">→</button></div></div>
        </div>
      </div>
    </main>

    <main v-else class="wrapped-page hobbies-page">
      <div class="container inner-page">
        <button class="back-button" @click="goHome">{{ t.back }}</button>
        <div class="wrapped-heading"><h1>{{ t.hobbies.title }}</h1></div>
        <div class="interest-layout hobbies-layout">
          <div class="interest-stack" :class="{ 'is-dragging': swipeType === 'hobbies' }" :style="{ '--drag-x': swipeType === 'hobbies' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'hobbies')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
            <article
              v-for="(item, index) in t.hobbies.items"
              :key="item.number"
              class="interest-card hobby-interest-card"
              :class="{ 'is-active': index === activeHobby, 'is-light': /acid|pink|blue/.test(item.color) }"
              :style="{ '--card-color': item.color, '--card-offset': `${(index - activeHobby + t.hobbies.items.length) % t.hobbies.items.length}` }"
            >
              <img v-if="item.photo && index === activeHobby" class="hobby-photo" :class="{ 'photo-inverted': item.photo === '/photos/mirror.jpg' }" :src="item.photo" :alt="item.photoAlt" loading="lazy" draggable="false">
              <small>{{ item.number }}</small>
              <span>{{ item.symbol }}</span>
              <h2>{{ item.title }}</h2>
              <em v-if="item.note">{{ item.note }}</em>
            </article>
          </div>
          <div class="interest-copy">
            <small>{{ t.hobbies.kicker }}</small>
            <h2>{{ currentHobby.title }}</h2>
            <p>{{ currentHobby.note }}</p>
            <p v-if="currentHobby.details" class="hobby-details">{{ currentHobby.details }}</p>
            <div class="card-controls"><button @click="moveInterest('hobbies', -1)">←</button><button @click="moveInterest('hobbies', 1)">→</button></div>
          </div>
        </div>
        <section v-if="activeHobby === 2" class="cycling-routes" :aria-label="t.hobbies.routes">
          <div class="cycling-routes-heading"><h3>{{ t.hobbies.routes }}</h3><span>{{ cyclingRoutes.length }}</span></div>
          <div class="cycling-routes-list">
            <button v-for="(route, index) in cyclingRoutes" :key="route.src" type="button" class="cycling-route-card" :aria-label="`${t.hobbies.openRoute}: ${t.hobbies.route} ${routeNumber(index)}, ${routeDistance(route)} km`" @click="openRoute(index, $event)">
              <span class="route-card-top"><span>{{ t.hobbies.route }} / {{ routeNumber(index) }}</span><span>↗</span></span>
              <strong>{{ routeDistance(route) }} <small>km</small></strong>
              <span class="route-card-meta">{{ routeDuration(route) }} <span>·</span> ≈ {{ routeSpeed(route) }} km/h</span>
              <span class="route-card-action">{{ t.hobbies.openRoute }} <span>→</span></span>
            </button>
          </div>
        </section>
      </div>
    </main>

    <div v-if="contactOpen" class="modal-backdrop" @click.self="contactOpen = false">
      <section class="social-modal" role="dialog" aria-modal="true" :aria-label="t.socialTitle">
        <button class="modal-close" :aria-label="t.back" @click="contactOpen = false">×</button>
        <small>{{ t.socialHint }}</small><h2>{{ t.socialTitle }}</h2>
        <a v-for="social in t.socials" :key="social.label" :href="social.href" :target="social.href.startsWith('http') ? '_blank' : undefined" :rel="social.href.startsWith('http') ? 'noopener noreferrer' : undefined">{{ social.label }} <span>{{ social.value }} ↗</span></a>
      </section>
    </div>

    <div v-if="routeOpen" class="modal-backdrop route-modal-backdrop" @click.self="closeRoute">
      <section ref="routeDialog" class="route-dialog" role="dialog" aria-modal="true" :aria-label="`${t.hobbies.route} ${routeNumber(activeRoute)}`" tabindex="-1" @keydown.esc="closeRoute" @keydown.left="moveInterest('routes', -1)" @keydown.right="moveInterest('routes', 1)">
        <button type="button" class="modal-close" :aria-label="t.hobbies.closeRoute" @click="closeRoute">×</button>
        <div class="route-dialog-heading"><small>{{ t.hobbies.routes }}</small><span>{{ routeNumber(activeRoute) }} / {{ cyclingRoutes.length }}</span></div>
        <div class="route-swipe-surface" :class="{ 'is-dragging': swipeType === 'routes' }" :style="{ '--drag-x': swipeType === 'routes' ? `${dragX}px` : '0px' }" @pointerdown="startSwipe($event, 'routes')" @pointermove="updateSwipe" @pointerup="finishSwipe" @pointercancel="cancelSwipe">
          <span class="route-swipe-index">{{ routeNumber(activeRoute) }}</span>
          <h2>{{ t.hobbies.route }}</h2>
          <div class="route-detail-stats">
            <div><small>{{ t.hobbies.distance }}</small><strong>{{ routeDistance(currentRoute) }} <span>km</span></strong></div>
            <div><small>{{ t.hobbies.duration }}</small><strong>{{ routeDuration(currentRoute) }}</strong></div>
            <div><small>{{ t.hobbies.speed }}</small><strong>≈ {{ routeSpeed(currentRoute) }} <span>km/h</span></strong></div>
          </div>
          <p>{{ t.hobbies.speedNote }}</p>
        </div>
        <div class="route-dialog-footer">
          <button type="button" class="route-nav-button" :aria-label="t.hobbies.previousRoute" @click="moveInterest('routes', -1)">←</button>
          <span>{{ t.hobbies.swipeRoutes }}</span>
          <button type="button" class="route-nav-button" :aria-label="t.hobbies.nextRoute" @click="moveInterest('routes', 1)">→</button>
        </div>
      </section>
    </div>
  </div>
</template>
