<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TareaController extends Controller
{
    public function get(){
        try{
            $data = DB::select("SELECT * FROM public.sps_tarea_all()");
            return response()->json($data,200);
        }catch(\Throwable $th){
            return response()->json(['error'=>$th->getMessage()],500);
        }
    }

    public function getTareaByTittle($titulo){
        try{
            $data = DB::select("SELECT * FROM public.sps_tarea_by_titulo(?)",[$titulo]);
            return response()->json($data,200);
        }catch(\Throwable $th){
            return response()->json(['error'=>$th->getMessage()],500);
        }
    }

    public function create(Request $request){
        try{
            $titulo=$request->input('titulo');
            $descripcion=$request->input('descripcion');
            $fechaEntrega=$request->input('fechaEntrega');

            DB::statement("SELECT public.spi_tarea_create(?,?,?)",[
                $titulo,
                $descripcion,
                $fechaEntrega
            ]);

            return response()->json(['mensaje' => 'Tarea creada correctamente'], 200);
        }catch(\Throwable $th){
            return response()->json(['error'=>$th->getMessage()],500);
        }
    }

    public function update(Request $request,$id){
        try{
            $titulo=$request->input('titulo');
            $descripcion=$request->input('descripcion');
            $fechaEntrega=$request->input('fechaEntrega');
            
            DB::statement("SELECT public.spu_tarea_updated(?,?,?,?)",[
                $id,$titulo,
                $descripcion,
                $fechaEntrega
            ]);
            return response()->json(['mensaje' => 'Tarea actualizada'], 200);
        }catch(\Throwable $th){
            return response()->json(['error'=>$th->getMessage()],500);
        }
    }

    public function updateTareaCompleted(Request $request,$id){
        try{
            DB::statement("SELECT public.spu_tarea_completed(?)",[$id]);

            return response()->json(['mensaje'=>'Tarea completada'],200);
        }catch(\Throwable $th){
            return response()->json(['error'=>$th->getMessage()],500);
        }
    }

    public function delete($id){
        try{
            DB::statement("SELECT public.spd_eliminar_tarea(?)",[$id]);
            return response()->json(['mensaje' => 'Tarea eliminada']);
        }catch(\Throwable $th){
            return response()->json(['error'=>$th->getMessage()],500);
        }
    }
}