import React, { useEffect,useState } from 'react';
import { obtenerCurso } from "../../actions/CursoAction";

const DetalleCurso = () => {

    const [imagen, setImagen] = useState("");

    useEffect(() => {

        obtenerCurso().then(response => {
            console.log('response', response);
            console.log('response', response.data.fotoPortada);
            setImagen("data:image/jpeg;base64," + response.data.fotoPortada)
        })


    }, [imagen])

    return (
        <div>
            <img src = {imagen}   />
        </div>
    );
};

export default DetalleCurso;