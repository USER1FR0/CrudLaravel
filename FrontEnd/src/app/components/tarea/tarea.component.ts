import { Component,OnInit } from '@angular/core';
import { TareaService,Tarea } from '../../services/tarea.service';

@Component({
  selector: 'app-tarea',
  templateUrl: './tarea.component.html',
  styleUrl: './tarea.component.css'
})
export class TareaComponent implements OnInit{

  tareas: Tarea[]=[];
  editando: boolean=false;
  busqueda:string='';
  mostrarModal: boolean = false;
  formTarea: Tarea={titulo:'',descripcion:'',fechaEntrega: new Date()};

  constructor(private tareaService: TareaService){}

  ngOnInit(): void{
    this.obtenerTareas();
  }

  abrirModalCrear(){
    this.editando=false;
    this.formTarea={titulo: '', descripcion: '', fechaEntrega: '' };
    this.mostrarModal = true;
  }

  abrirModalEditar(tarea:Tarea){
    this.editando=true;
    this.formTarea={...tarea};
    this.mostrarModal=true;
  }

  cerrarModal(){
    this.mostrarModal=false;
    this.formTarea={titulo: '', descripcion: '', fechaEntrega: '' };
    this.editando=false;
  }

  obtenerTareas():void{
    this.tareaService.getTareas().subscribe(data=>{
      console.log('Tareas: ',data);
      this.tareas=data.map((t: any)=>({
        id: t.tarea_id,
        titulo:t.tarea_titulo,
        descripcion:t.tarea_descripcion,
        fechaEntrega:t.tarea_fechaentrega,
        estado:t.tarea_estado
      }))
    })
  }

  buscarTareaByTitulo():void{
    if(this.busqueda.trim()){
      this.tareaService.getTareaByTittle(this.busqueda).subscribe(data=>{
        this.tareas=data.map((t: any)=>({
        id: t.tarea_id,
        titulo:t.tarea_titulo,
        descripcion:t.tarea_descripcion,
        fechaEntrega:t.tarea_fechaentrega,
        estado:t.tarea_estado
      }))
      });
    }else{
      this.obtenerTareas();
    }
  }

  crearTarea():void{
    const formData = new FormData();

    formData.append('titulo',this.formTarea.titulo);
    if(this.formTarea.descripcion){
      formData.append('descripcion',this.formTarea.descripcion);
    }

    if (this.formTarea.fechaEntrega) {
      const fecha = new Date(this.formTarea.fechaEntrega);
      const fechaStr = fecha.toISOString().split('T')[0];
      formData.append('fechaEntrega', fechaStr);
    }

    if(!this.formTarea.titulo || !this.formTarea.descripcion || !this.formTarea.fechaEntrega){
      alert ('Debes llenar todos los campos :)')
      return;
    }

    this.tareaService.createTarea(formData).subscribe(() =>{
      this.obtenerTareas();
      this.cerrarModal();
    });
  }

  editarTarea(tarea:Tarea):void{
    this.formTarea = { ...tarea};
    this.editando=true;
  }

  /*pendiente(tarea: Tarea):boolean{
    return tarea.estado == true;
  }*/

  actualizarTarea(): void {

    if(!this.formTarea.titulo || !this.formTarea.descripcion || !this.formTarea.fechaEntrega){
      alert ('Debes llenar todos los campos :)')
      return;
    }

    if (this.formTarea.id) {
      this.tareaService.updateTarea(this.formTarea.id, this.formTarea).subscribe(() => {
        this.obtenerTareas();
        this.cerrarModal();
      });
  }
}


  eliminarTarea(id:number):void{
    this.tareaService.deleteTarea(id).subscribe(()=>{
      this.obtenerTareas();
    });
  }

  completarTarea(id:number): void{
    this.tareaService.completedTarea(id).subscribe(()=>{
      this.obtenerTareas();
    })
  }

}
