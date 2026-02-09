# Holy Family Stay - Room Booking System

A modern, full-stack room booking application built with React, Supabase, and Resend.

## Features

- ✅ Customer registration and login
- ✅ Real-time room availability checking
- ✅ Multi-room booking (max 5 rooms per booking)
- ✅ Admin dashboard with room management
- ✅ Email confirmations with Resend
- ✅ CSV/Excel export for bookings
- ✅ Responsive design for mobile, tablet, and desktop
- ✅ Floor-based room organization (23 rooms total)

## Tech Stack

- **Frontend**: React 18, Vite, TailwindCSS
- **Backend**: Supabase (PostgreSQL + Auth)
- **Email**: Resend
- **Deployment**: Vercel
- **State Management**: React Hooks

## Room Configuration

- **Old Block**: Rooms 1, 2 (2 rooms)
- **Floor 1**: Rooms 10-16 (7 rooms)
- **Floor 2**: Rooms 20-26 (7 rooms)
- **Floor 3**: Rooms 30-36 (7 rooms)
- **Total**: 23 rooms

## Getting Started

### Prerequisites

- Node.js 18+ and npm
- Supabase account
- Resend account
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/holy-family-stay.git
cd holy-family-stay
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
Create a `.env.local` file in the root directory:
```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
RESEND_API_KEY=your_resend_api_key
VITE_APP_URL=http://localhost:5173
```

4. Run Supabase migrations:
```bash
# Copy the SQL from supabase/migrations/001_initial_schema.sql
# and run it in your Supabase SQL Editor
```

5. Start the development server:
```bash
npm run dev
```

6. Open https://holy-family-home-stay.vercel.app/

## Deployment

### Deploy to Vercel

1. Push code to GitHub
2. Connect repository to Vercel
3. Add environment variables in Vercel dashboard
4. Deploy

```bash
npm run build
vercel --prod
```

## Database Schema

See `supabase/migrations/001_initial_schema.sql` for complete schema.

## Email Templates

Customizable email templates in `src/utils/emailTemplates.js`.


## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

MIT License

## Troubleshooting

### Windows PowerShell "Script Not Loaded" Error
If you see an error like `File ...\npm.ps1 cannot be loaded because running scripts is disabled`, it is due to PowerShell execution policies.

**Solution 1: Run with CMD**
Use the Command Prompt (cmd) instead of PowerShell.
```bash
cmd /c "npm run dev"
```

**Solution 2: Allow Scripts (Temporary)**
Run this in PowerShell before strting the server:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
