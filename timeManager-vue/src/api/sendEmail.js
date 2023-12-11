import axios from 'axios'

export const sendEmail = async (name, email, subject, content) => {
  const apiKey =
    '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'
  const emailData = {
    sender: {
      name: 'TimeManager',
      email: 'noreply@timemanager.com'
    },
    to: [
      {
        email: email,
        name: name
      }
    ],
    subject: subject,
    htmlContent: '<html><head></head><body><p>Hello,</p>' + content + '</p></body></html>'
  }

  const headers = {
    accept: 'application/json',
    'api-key': apiKey,
    'content-type': 'application/json'
  }
  try {
    const response = await axios.post('https://api.brevo.com/v3/smtp/email', emailData, { headers })
    return response
  } catch (error) {
    return false
  }
}

export default sendEmail
