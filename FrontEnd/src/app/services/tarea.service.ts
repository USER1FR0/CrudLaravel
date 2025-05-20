import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError, Observable } from 'rxjs';
import { environment} from '../../enviroments/enviroment';

export interface Tarea{
  id?:number;
  titulo: string;
  descripcion?:string;
  fechaEntrega?:Date | string;
  estado?: boolean;
}

@Injectable({
  providedIn: 'root'
})

export class TareaService {

  private apiUrl = environment.apiUrl;

  constructor(private http: HttpClient) { }

  // Obtener Todas las Tareas.
  getTareas():Observable<any>{
    return this.http.get(`${this.apiUrl}`);
  }

  //Obtener Tareas Mediante Titulo.
  getTareaByTittle(t_tarea:string):Observable<any>{
    return this.http.get(`${this.apiUrl}/${t_tarea}`);
  }

  //Crear Tarea.
  createTarea(tarea:FormData):Observable<any>{
    return this.http.post(`${this.apiUrl}`,tarea).pipe(
      catchError((error:any)=>{
        console.error('Error al registrar empleado: ',error);
        throw error;
      })
    )
  }

  //Editar Tarea.
  updateTarea(id: number,data:any): Observable<any>{
    return this.http.put(`${this.apiUrl}/${id}`,data);
  }

  //Marcar Tarea Como Completado.
  completedTarea(id:number):Observable<any>{
    return this.http.put(`${this.apiUrl}/completar/${id}`,{});
  }

  //Eliminar Tarea.
  deleteTarea(id:number):Observable<any>{
    return this.http.delete(`${this.apiUrl}/${id}`);
  }
  
}