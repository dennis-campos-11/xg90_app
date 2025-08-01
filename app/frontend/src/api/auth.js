import api from '@/api'

export async function signIn(email, password) {
  const response = await api.post('/sign_in', { 
    user: {
      email: email, 
      password: password 
    }
  })
  return response.data
}

export async function signUp(firstName, lastName, email, password, passwordConfirmation) {
  const response = await api.post('/sign_up', { 
    user: {
      first_name: firstName,
      last_name: lastName,
      email: email,
      password: password,
      password_confirmation: passwordConfirmation
    }
  })
  return response.data
}

export async function forgotPassword(email) {
  const response = await api.post('/password/forgot', { 
    user: {
      email: email 
    }
  })
  return response.data
}

export async function resetPassword(resetPasswordToken, password, passwordConfirmation) {
  const response = await api.post('/password/reset', { 
    reset_password_token: resetPasswordToken,
    user: { 
      password: password,
      password_confirmation: passwordConfirmation
    }
  })
  return response.data
}
