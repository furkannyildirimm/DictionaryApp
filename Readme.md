# English Dictionary and Pronunciation App

This application provides a dictionary that displays the meanings of English words and an interface that shows the word types (noun, verb, adjective, etc.). Additionally, it features an audio playback function that allows you to hear the correct pronunciation of the words.

## Features

The application provides a user-friendly interface and includes the following features:

- **Word Search**: Enter the word you want to search in the search box and click the "Search" button. The dictionary will display the meaning, pronunciation, and part of speech (noun, verb, adjective, adverb, etc.) of the word.
- **Parts of Speech**: The dictionary indicates the part of speech for each word. For example, it shows whether a word is a noun, verb, adjective, or any other part of speech.
- **Audio Pronunciation**: There is a speaker icon next to each word. When you click on this icon, you can listen to the correct pronunciation of the word.
- **Examples**: Underneath the meaning of the word, there are usage examples. These examples demonstrate how the word is used and how it fits into a sentence.

## Design Pattern: MVVM (Model-View-ViewModel)

In this project, we preferred to use the Model-View-ViewModel (MVVM) design pattern.

![1](Image/1.png)

### What is?
- MVVM (Model-View-ViewModel) is a design pattern used in software development. This pattern separates the user interface (View) from the data and logic (Model), utilizing a mediator layer called ViewModel as a communication bridge between them.

- MVVM reduces the complexity of software by making application code easier to understand, maintain, and enhance. It also increases the testability of the software and facilitates easier design of the user interface.

###Basic Components

The MVVM design pattern includes the following basic components:

- **Model**: The Model is the component that holds and processes the data. It typically interacts with databases, file systems, or web services. The Model is independent of the user interface.
- **View**: The View is the visual component of the user interface. It is where the user sees and interacts with the data. The View is independent of the Model and communicates with the ViewModel
- **ViewModel**: The ViewModel connects the Model and the View. It provides data to the View and processes user interactions performed on the View. The ViewModel updates the Model and provides feedback to the View.

## Requirements

- Swift 5.0 or higher
- Xcode 13.0 or higher

## Screenshot

Iphone 14 Pro            | Iphone 14 Pro Max          
:-------------------------:|:-------------------------:
![](https://github.com/furkannyildirimm/FurkanYildirim_HW3/blob/main/GIFs/1.gif)  |  ![](https://github.com/furkannyildirimm/FurkanYildirim_HW3/blob/main/GIFs/3.gif) 

## Used Technologies

- Swift: A programming language used for iOS app development.
- Dictionary API: An English dictionary API that allows you to fetch the definitions, parts of speech, and example sentences of English words. This API uses the URL structure "https://api.dictionaryapi.dev/api/v2/entries/en/{word}" where you can replace {word} with the desired English word to make the request. The API response is in JSON format and includes the different meanings, example sentences, and part of speech for the requested word.
- Alamofire: A Swift library used for making HTTP requests.
- AVFoundation: A Swift framework used for playing audio pronunciations.
- Core Data: A framework used for local data storage.



## Communication
- If you have any questions, suggestions, or feedback, you can reach us at the following email address: [furkannyildirimm@hotmail.com]

