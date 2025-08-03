<template>
  <div class="min-h-screen w-full flex items-center justify-center">
    <div class="flex w-full flex-col lg:flex-row min-h-screen">
      <router-view />
      <!-- Right: Info Panel -->
      <div class="flex flex-1 items-center justify-center bg-gray-900 text-white p-12">
        <div class="max-w-md">
          <div class="flex items-center mb-4">
            <svg class="h-8 w-8 mr-2 text-white" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M12 0C5.371 0 0 5.371 0 12s5.371 12 12 12 12-5.371 12-12S18.629 0 12 0zm0 22.154C6.124 22.154 1.846 17.876 1.846 12S6.124 1.846 12 1.846 22.154 6.124 22.154 12 17.876 22.154 12 22.154z" />
            </svg>
            <span class="text-xl font-bold">XG90</span>
          </div>
          <h2 class="text-3xl font-extrabold mb-4">
            Join the most complete football stats platform.
          </h2>
          <p class="text-lg mb-6">
            Unlock access to performance data, match history, xG and insights trusted by thousands of analysts and fans.
          </p>
          <div class="text-white font-medium">
            Already helping <span class="font-bold">3k+</span> users.
          </div>
        </div>
      </div>
    </div>
  </div>
</template>