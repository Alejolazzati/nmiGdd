using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_de_Usuario
{
    public partial class ModPreguntayResp : Form
    {
        int usuario;
        public ModPreguntayResp(int codUser)
        {
            InitializeComponent();
            usuario = codUser;
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select Pregunta_secreta from NMI.Usuario where id_usuario=" + codUser;
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            textBox1.Text = reader.GetValue(0).ToString();
            reader.Dispose();
        }

        private void ModPreguntayResp_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox2.Text.Length == 0) { MessageBox.Show("Complete la respuesta"); return; }
            if (textBox2.Text != textBox3.Text) { MessageBox.Show("Las respuestas no coinciden"); return; }
            if (textBox1.Text.Length == 0) { MessageBox.Show("Complete la pregunta secreta"); return; }
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            String Respuesta = Encriptar.SHA256(textBox2.Text);
            comando.CommandText = "update NMI.Usuario set Pregunta_secreta='"+ textBox1.Text+"' ,respuesta='"+Respuesta+"'where id_usuario="+ usuario;
            comando.ExecuteNonQuery();
            MessageBox.Show("Actualizacion correcta");
            this.Close();
        }
    }
}
