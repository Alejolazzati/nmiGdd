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
    public partial class ModificarRol : Form
    {
        int usuario;
        public ModificarRol(int user)
        {
            usuario = user;
            InitializeComponent();
        }

        private void ModificarRol_Load(object sender, EventArgs e)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select descripcion from NMI.rolesDeUsuario(" + usuario.ToString()+")";
            System.Data.SqlClient.SqlDataReader reader =comando.ExecuteReader();
            while(reader.Read())
            {
                listBox1.Items.Add(reader.GetSqlValue(0).ToString());
            }
            reader.Dispose();
            comando = Coneccion.getComando();
            comando.CommandText = "Select descripcion from NMI.rolesFaltantesUsuario(" + usuario.ToString() + ")";
            reader = comando.ExecuteReader();
            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0).ToString());
            }
            reader.Dispose();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (listBox1.SelectedItem != null)
            {
                listBox2.Items.Add(listBox1.SelectedItem);
                listBox1.Items.Remove(listBox1.SelectedItem);
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (listBox2.SelectedItem != null)
            {
                listBox1.Items.Add(listBox2.SelectedItem);
                listBox2.Items.Remove(listBox2.SelectedItem);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
             try
                {
                    System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
                    comando.CommandText = "begin transaction Create table #tablaTemporal (rol varchar(50))";
                    comando.ExecuteNonQuery();
                    foreach (Object unRol in listBox1.Items)
                    {
                        // System.Data.SqlTypes.SqlString funcionalidad = func.
                        String rol = unRol.ToString();
                        comando.CommandText = "insert into #tablaTemporal values('" + rol + "')";
                        comando.ExecuteNonQuery();
                    }

                    comando.CommandText = "exec nmi.agregarRolesUsuario " + usuario + " commit";
                    comando.ExecuteNonQuery();
                    MessageBox.Show("Operacion exitosa");
                    this.Close();

                }
                catch (System.Data.SqlClient.SqlException er) { MessageBox.Show(er.Message); }

            
        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
