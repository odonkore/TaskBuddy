# Overview

The software is a Task Manager application that allows users to create, manage, and track tasks effectively. Users can add tasks with titles, descriptions, due dates, and completion statuses. The app integrates with Firebase Firestore, a cloud-based NoSQL database, to store and manage task data. Tasks are automatically synchronized across devices in real-time, and any updates to the tasks (e.g., marking a task as completed) are reflected instantly. The application also includes user authentication with Firebase, ensuring secure access to personal task data.

How to Use:
- Sign Up/Log In: Upon opening the app, users can sign up using email/password. The app requires only a one time sign in until logout.

- Dashboard: Once logged in, users are directed to the Dashboard screen, which displays tasks by their due date. Users can mark tasks as completed using a checkbox.

- Add a Task: Users can add new tasks by navigating to the "Add Task" screen via the bottom navigation bar or the floating action button. Here, users can provide a title, description and due date.

- Task List: Users can view all tasks by navigating to the Task List screen, where they can see all tasks in more detail, edit and delete tasks.

The purpose of this software is to provide a user-friendly task management app that helps users organize and track their tasks, while enhancing my skills in software development. It integrates with a cloud database for real-time synchronization and secure access to personal task data.

{Provide a link to your YouTube demonstration. It should be a 4-5 minute demo of the software running, a walkthrough of the code, and a view of the cloud database.}

[Software Demo Video](http://youtube.link.goes.here)

# Cloud Database

I used Firebase Firestore as my cloud database for this app. Firestore is a NoSQL database that allows developers to store and sync data in real-time. It is highly scalable, secure, and provides smooth integration with Firebase Authentication for user management. For this task manager app, data is stored in a collection, including fields like title, description, due date and completion status, allowing for efficient querying and updates.

The database consists of a single collection called "tasks" in Firestore, where each document represents an individual task. Each task document contains the following fields:

title: The title or name of the task (string).

description: A brief description of the task (string).

dueDate: The due date and time for the task (timestamp).

isCompleted: A boolean indicating whether the task has been completed (boolean).

createdAt: The timestamp when the task was created (timestamp).

# Development Environment

- Flutter
- Visual Studio Code

- Dart

# Useful Websites

- [Google Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Beginners Guide](https://youtu.be/9kRgVxULbag?si=332xJg-irNctkxQg)

# Future Work

- Swipe to delete feature
- Priority feature
- Realtime notification when task is due.
- Group tasks into categories
- Group task on dashboards into today, upcoming, past, etc.
- 

Users will be able to simply swipe to delete a task without having to navigate to the task list screen. Tasks will be grouped by category, thus giving the user an option to choose a category for a task. On the dashboad, the tasks displayed will be grouped based on the condition whether the task is due today, past, or upcoming. Users will also be given the option to add priority level to each task, with that in place, high proirity tasks will displayed at the top and in red. Users will have option to receive notification when task is due.
