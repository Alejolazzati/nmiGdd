using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Rol
{
    public partial class formRol : Form
    {
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public formRol()
        {
            InitializeComponent();
            
            //cargar posibles estados de rol
            comando.CommandText = "select NMI.Estado_rol.Descripcion from NMI.Estado_rol";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();


            //cargar funcionalidas
            comando.CommandText = "select NMI.Funcionalidad.Descripcion from NMI.Funcionalidad";
            reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();




        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void groupBox2_Enter(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (listBox2.SelectedItem != null)
            {
                listBox1.Items.Add(listBox2.SelectedItem);
                listBox2.Items.Remove(listBox2.SelectedItem);
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (listBox1.SelectedItem != null)
            {
                listBox2.Items.Add(listBox1.SelectedItem);
                listBox1.Items.Remove(listBox1.SelectedItem);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            //inserto nombreDenuevoRol
            if (textBox1.Text.Length == 0) { MessageBox.Show("Complete el nombre del nuevo rol"); return; }
            if (comboBox2.SelectedIndex == -1) { MessageBox.Show("Seleccione el estado del nuevo rol"); return; }

            String nombreRolNuevo = textBox1.Text;
            Int32 id_rol;
            comando.CommandText = "NMI.ingresarNuevoRol";
            comando.CommandType = CommandType.StoredProcedure;
            comando.Parameters.Add("@nombreRol", SqlDbType.VarChar);
            comando.Parameters.Add("@Id_rol", SqlDbType.Int);
            comando.Parameters["@nombreRol"].Value = nombreRolNuevo;
            comando.Parameters["@id_rol"].Direction = ParameterDirection.Output;
            try
            {
                comando.ExecuteNonQuery();
                id_rol = Int32.Parse(comando.Parameters["@id_rol"].SqlValue.ToString());

                comando.Parameters.Clear();
                comando.CommandType = CommandType.Text;
                //agregar el estado
               
                String estado = comboBox2.SelectedItem.ToString();
                comando.CommandText = "exec nmi.actualizarEstado '" + estado + "'," + id_rol;
                comando.ExecuteNonQuery();

                //agrego las funcionalidades

                foreach (Object funci in listBox1.Items)
                {
                    // System.Data.SqlTypes.SqlString funcionalidad = func.
                    String func = funci.ToString();
                    comando.CommandText = "exec nmi.actualizarFuncionalidadEstado '" + func + "'," + id_rol;
                    comando.ExecuteNonQuery();
                }


                MessageBox.Show("Nuevo Rol Creado");
                this.Close();

            }
            catch (NullReferenceException ex)
            {
                MessageBox.Show("Ingrese nombre rol y estado rol");
            }
            catch (System.Data.SqlClient.SqlException er)
            {
                comando.Parameters.Clear();
                comando.CommandType = CommandType.Text;
                MessageBox.Show(er.Message);
                new PagoElectronico.Login.Funcionalidades().Show();
                this.Close();

            }
                   
            
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
