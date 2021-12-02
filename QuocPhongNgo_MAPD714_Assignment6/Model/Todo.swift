/**
 * Assignment 5
 * File Name:    Todo.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   November 28th, 2021
 */
   
import Foundation

class Todo
{
    private var m_id: String
    private var m_name: String
    private var m_notes: String
    private var m_hasDueDate: Bool
    private var m_dueDate: String
    private var m_isCompleted: Bool
    
    // public properties
    public var name: String
    {
        get
        {
            return m_name
        }
        
        set(newName)
        {
            m_name = newName
        }
    }
    
    public var isCompleted: Bool
    {
        get
        {
            return m_isCompleted
        }
        
        set(newIsCompleted)
        {
            m_isCompleted = newIsCompleted
        }
    }
    
    public var notes: String
    {
        get
        {
            return m_notes
        }
        
        set(newNotes)
        {
            m_notes = newNotes
        }
    }
    
    public var hasDueDate: Bool
    {
        get
        {
            return m_hasDueDate
        }
    }
    
    public var dueDate: String
    {
        get
        {
            return m_dueDate
        }
        
        set(newDueDate)
        {
            m_dueDate = newDueDate
            m_hasDueDate = true
        }
    }
    
    // initializer (constructor)
    init(name: String, notes:String = "", hasDueDate:Bool = false, dueDate:String = "", isCompleted:Bool = false)
    {
        m_name = name
        m_notes = notes
        m_hasDueDate = hasDueDate
        m_dueDate = dueDate
        // generate random id based on date hashValue
        m_id = "\(abs(m_dueDate.hashValue))"
        m_isCompleted = isCompleted
    }
    
}

