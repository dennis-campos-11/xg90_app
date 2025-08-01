import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'

import MainLayout from '@/layouts/MainLayout.vue'
import AuthLayout from '@/layouts/AuthLayout.vue'
import SignInView from '../views/auth/SignInView.vue'
import SignUpView from '../views/auth/SignUpView.vue'
import ProtectedView from '../views/ProtectedView.vue'
import ForgotPasswordView from '@/views/auth/ForgotPasswordView.vue'
import ResetPasswordView from '@/views/auth/ResetPasswordView.vue'
import FixtureListsShowView from '@/views/fixtures_lists/ShowView.vue'
import FixtureListsIndexView from '@/views/fixtures_lists/IndexView.vue'

const routes = [
  {
    path:'/',
    component: AuthLayout,
    children:[
      { 
        path: '/sign_in', 
        component: SignInView
      },
      { 
        path: '/sign_up', 
        component: SignUpView,
      },
      { 
        path: '/forgot_password', 
        component: ForgotPasswordView,
      },
      { 
        path: '/reset_password', 
        component: ResetPasswordView,
      },
    ]
  },
  {
    path:'/',
    component: MainLayout,
    children:[
      { 
        path: '/protected', 
        component: ProtectedView
      },
      { 
        path: '/fixture_lists', 
        component: FixtureListsIndexView,
        meta: { requiresAuth: true }
      },
      { 
        path: '/fixture_lists/:id', 
        component: FixtureListsShowView,
        meta: { requiresAuth: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to) => {
  const store = useUserStore()
  if (to.meta.requiresAuth && !store.token) {
    return '/sign_in'
  }
})

export default router
