//
//  ViewController.swift
//  TaskApp
//
//  Created by mcor on 22/10/23.
//

import UIKit
import TaskManagerModule

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Adicionar Tarefa", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    
    // Instancia o TaskManager
    let taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        view.addSubview(addButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 4),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 180)
            
        ])
        
        
        // Registra as células
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Define o delegate e dataSource da TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Adiciona uma tarefa de exemplo
        taskManager.addTask(Task(title: "TaskApp", completed: true))
        
        addButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
    }
    
    // Retorna a quantidade de tarefas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskManager.getAllTasks().count
    }
    
    
    // Configura as células
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = taskManager.getAllTasks()[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
    
    @objc func addTaskButtonTapped() {
        let alertController = UIAlertController(title: "Nova Tarefa", message: "Digite o título da tarefa", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Título da Tarefa"
        }
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { [weak self] _ in
            guard let self = self, let title = alertController.textFields?.first?.text else { return }
            let newTask = Task(title: title, completed: false)
            self.taskManager.addTask(newTask)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

