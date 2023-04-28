The current system is a web application built with the following tech stack: javascript, vue@2.6, vuex@3, vue-router@3, and vuetify@2.

All codes should be written in the tech stack mentioned above.
Requirements should be implemented as Vue components in the components architecture pattern.

The system has several types of view model, including:

1. Shared view model: A view model that represents states shared among local and remote users.

2. Local view model: A view model that represents states only applicable to the local user.

3. Navigation view model: A view model that manages the application's navigation state, including routing and page transitions. This is implemented using vue-router@3.

Here are the common implementation strategies:

1. Shared view model is implemented as a vuex module. Use vuex-store-unit-helper for testing.

2. Local view model is implemented as a Vue component's props or states (by using Vue's reactive data), unless it's global local view model, which is also implemented as a vuex module.

3. Computed properties are used as the major view helpers to retrieve data from shared view model. For most cases, it will use getters and mapGetters for memorization. Use vue-test-utils for testing.

4. Don’t modify the states of shared view model directly, use an encapsulated view model interface instead. In the interface, each vuex mutation is mapped to a method. Use vuex-store-unit-helper for testing.

5. Views are implemented as Vue components. Vuetify components are preferred over native HTML elements. Use jest for unit testing and cypress for end-to-end testing.

6. Navigation view model is implemented using vue-router@3. Use the router-link component for declarative navigation and the $router property for programmatic navigation. Use vue-test-utils to test navigation.

Here are certain patterns that should be followed when implementing and testing components:

1. When writing tests, use `describe` instead of `test`.

2. Data-driven tests are preferred.

3. When testing the view component, fake view model via the view model interface.


Requirement: 

{{  }}

Provide an overall solution following the guidance mentioned above.
Don’t generate code. Describe
the solution, and breaking the solution down as a task list based on the
guidance mentioned above. And we will refer this task list as our master
plan.
