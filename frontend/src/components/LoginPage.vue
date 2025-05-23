<template>
  <div class="login-container">
    <h2>ログイン</h2>
    <form @submit.prevent="handleLogin" class="login-form">
      <div class="form-group">
        <label for="email">メールアドレス:</label>
        <input type="email" id="email" v-model="credentials.email" required />
      </div>
      <div class="form-group">
        <label for="password">パスワード:</label>
        <input type="password" id="password" v-model="credentials.password" required />
      </div>
      <button type="submit" :disabled="isLoading" class="submit-button">
        {{ isLoading ? 'ログイン中...' : 'ログイン' }}
      </button>
      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { login } from '@/api/auth.ts';
import { AxiosError } from 'axios';

const credentials = ref({
  email: '',
  password: ''
});

const errorMessage = ref<string | null>(null);
const isLoading = ref<boolean>(false);

const handleLogin = async () => {
  isLoading.value = true;
  errorMessage.value = null;

  try {
    await login(credentials.value);
  } catch (error) {
    console.error('ログイン失敗:', error);
    if (error instanceof AxiosError && error.response && error.response.data) {
      const responseData = error.response.data;
      if (responseData.errors && Array.isArray(responseData.errors)) {
        errorMessage.value = responseData.errors.join(', ');
      } else if (responseData.message) {
        errorMessage.value = responseData.message;
      } else if (responseData.error) {
        errorMessage.value = responseData.error;
      } else {
        errorMessage.value = 'ログインに失敗しました。メールアドレスまたはパスワードが正しくない可能性があります。';
      }
    } else if (error instanceof Error) {
      errorMessage.value = error.message;
    } else {
      errorMessage.value = '予期せぬエラーが発生しました。';
    }
  } finally {
    isLoading.value = false;
  }
};
</script>

<style scoped>
.login-container {
  max-width: 400px;
  margin: 50px auto;
  padding: 30px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  background-color: #fff;
}

h2 {
  text-align: center;
  color: #333;
  margin-bottom: 25px;
}

.login-form {
  display: flex;
  flex-direction: column;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: bold;
  color: #555;
}

.form-group input {
  width: 100%;
  padding: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  font-size: 16px;
}

.form-group input:focus {
  border-color: #007bff;
  outline: none;
  box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
}

.submit-button {
  padding: 12px 15px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s ease;
}

.submit-button:hover:not(:disabled) {
  background-color: #0056b3;
}

.submit-button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.error-message {
  color: #dc3545;
  margin-top: 15px;
  text-align: center;
  font-weight: bold;
}
</style>