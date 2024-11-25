from django.forms import ValidationError
from django.shortcuts import render, redirect
from django.contrib import messages
from .models import Credential as User  # Import the custom user model
from django.core.validators import validate_email  # Import validate_email


def login(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')

        # Check if user exists
        user = User.objects.filter(email=email).first()
        if user:
            if user.check_password(password):
                # Login logic here (e.g., session management)
                messages.success(request, f"Welcome, {user.first_name} {user.last_name}")
                return redirect('register')
            else:
                messages.error(request, 'Invalid credentials')
                return redirect('register')
        else:
            messages.error(request, 'User does not exist')
            return redirect('login')
    return render(request, 'pages/login.html')

# view register page
def register(request):
    if request.method == 'POST':
        # Get form data
        username = request.POST.get('username')
        password = request.POST.get('password')
        first_name = request.POST.get('first_name')
        last_name = request.POST.get('last_name')
        email = request.POST.get('email')

        # Validate required fields
        if not username or not password:
            messages.error(request, 'Username and password are required')
            return redirect('register')

        # Check username length and characters
        if len(username) > 150:
            messages.error(request, 'Username must be 150 characters or fewer')
            return redirect('register')

        # Check if username already exists
        if User.objects.filter(username=username).exists():
            messages.error(request, 'A user with that username already exists')
            return redirect('register')

        # Validate email if provided
        if email:
            try:
                validate_email(email)
                if User.objects.filter(email=email).exists():
                    messages.error(request, 'Email already registered')
                    return redirect('register')
            except ValidationError:
                messages.error(request, 'Please enter a valid email address')
                return redirect('register')

        # Validate password
        if len(password) < 8:
            messages.error(request, 'Password must be at least 8 characters long')
            return redirect('register')

        try:
            # Create user
            user = User.objects.create_user(
                username=username,
                email=email or None,  # Set to None if email is empty
                password=password,
                first_name=first_name,
                last_name=last_name
            )

            messages.success(request, 'Account created successfully')
            return redirect('login')

        except Exception as e:
            messages.error(request, 'An error occurred while creating your account')
            return redirect('register')

    return render(request, 'pages/register.html')

# view logout page
def get_all_users(request):
    users = User.objects.all()
    return render(request, 'pages/index.html', {'users': users})