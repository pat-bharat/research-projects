import React, {useState} from 'react'
import axios from 'axios'

export default function App() {
  const [handle, setHandle] = useState('@demo-user')
  const [amount, setAmount] = useState('1.00')
  const [note, setNote] = useState('Test payout')
  const [response, setResponse] = useState(null)
  const [csrfToken, setCsrfToken] = useState(null)
  const [loading, setLoading] = useState(false)

  
React.useEffect(() => {
  // fetch CSRF token
  axios.get('/api/auth/csrf').then(r => {
    setCsrfToken(r.data.token)
  }).catch(e => {
    console.warn('CSRF fetch failed', e)
  })
}, [])

  const sendPayout = async () => {
    setLoading(true)
    setResponse(null)
    try {
      const res = await axios.post('/api/payouts/venmo', {
        handle, amount, currency: 'USD', note
      })
      setResponse(res.data)
    } catch (e) {
      setResponse({ error: e.message, details: e.response ? e.response.data : null })
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{fontFamily:'Arial, sans-serif', maxWidth:720, margin:'40px auto'}}>
      <h1>PayPal Venmo Sandbox Demo</h1>
      <div style={{marginBottom:12}}>
        <label>Venmo Handle: </label>
        <input value={handle} onChange={e=>setHandle(e.target.value)} style={{marginLeft:8}} />
      </div>
      <div style={{marginBottom:12}}>
        <label>Amount USD: </label>
        <input value={amount} onChange={e=>setAmount(e.target.value)} style={{marginLeft:8}} />
      </div>
      <div style={{marginBottom:12}}>
        <label>Note: </label>
        <input value={note} onChange={e=>setNote(e.target.value)} style={{marginLeft:8, width:400}} />
      </div>
      <div style={{marginBottom:12}}>
        <button onClick={()=> window.open('/api/oauth/login','_blank')}>Connect PayPal</button>
      </div>
      <div>
        <button onClick={sendPayout} disabled={loading}>{loading ? 'Sending...' : 'Send Test Payout'}</button>
      </div>
      <pre style={{background:'#f6f6f6', padding:12, marginTop:16}}>{JSON.stringify(response, null, 2)}</pre>
    </div>
  )
}
