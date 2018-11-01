<template>
    <div class="container" style="margin-top: 20px;">
        <ul class="list-group">
            <li class="list-group-item" v-for="task in tasks" v-text="task"></li>
        </ul>
        <hr>
        <form @submit.prevent="addTask" method="post">
            <div class="form-group">
                <input v-model="newTask" type="text" class="form-control" placeholder="Add a Task">
            </div>
            <button class="btn btn-primary">Submit</button>
        </form>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                tasks: [],
                newTask: ''
            }
        },
        mounted() {
            axios.get('/tasks').then(response => {
                this.tasks = response.data
            });
            window.Echo.channel('tasks').listen('TaskCreated', e => {
//                console.log(e.task.body);
                this.tasks.push(e.task.body);
            });
        },
        methods: {
            addTask() {
                axios.post('/tasks',{body: this.newTask});
                this.tasks.push(this.newTask);
                this.newTask = '';
            }
        }

    }
</script>
