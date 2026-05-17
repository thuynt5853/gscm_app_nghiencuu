using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace WEB.GSTP.QTCucTHA.Nhomnguoidung
{
    public partial class Phanquyen : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        public  bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string strID = Request["CID"] + "";
                if (strID != "")
                {
                    decimal IDNhom = Convert.ToDecimal(strID);
                    LoadMenuByChuongtrinh(IDNhom);
                    TUPHAP_NHOMNGUOIDUNG oT = dt.TUPHAP_NHOMNGUOIDUNG.Where(x => x.ID == IDNhom).FirstOrDefault();
                    if (oT == null) return;
                    lstName.Text = oT.TEN;
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
        }
        private void LoadMenuByChuongtrinh(decimal NhomID)
        {
            cmdUpdate.Visible = Button1.Visible = dgMenu.Visible = true;
            lstMess.Text=lstMsgB.Text = "";
            QT_TUPHAP_BL qtBL = new QT_TUPHAP_BL();
            dgMenu.DataSource = qtBL.QT_NHOMNGUOIDUNG_MENU_GETBY_THADS(NhomID);
            dgMenu.DataBind();
        }

        private TreeNode CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            if (sNodeId == Guid.Empty.ToString())
            {
                objTreeNode.ImageUrl = "../../UI/img/root.gif";
            }
            return objTreeNode;
        }

        protected void treemenu_SelectedNodeChanged(object sender, EventArgs e)
        {
            cmdUpdate.Visible = Button1.Visible = dgMenu.Visible = true;
            LoadMenuByChuongtrinh(Convert.ToDecimal(Request["CID"]));
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lstMess.Text = lstMsgB.Text = "";
            string strNhomID = Request["CID"] + "";
            decimal IDNhom = Convert.ToDecimal(strNhomID);
            foreach (DataGridItem Item in dgMenu.Items)
            {
                string strID = Item.Cells[0].Text;
                decimal IDMenu = Convert.ToDecimal(strID);
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                List<TUPHAP_NHOMNGUOIDUNG_MENU> lst = dt.TUPHAP_NHOMNGUOIDUNG_MENU.Where(x => x.MENUID == IDMenu && x.NHOMID == IDNhom).ToList();
                if (lst.Count == 0)
                {
                    if (chkXem.Checked || chkCapnhat.Checked || chkTaomoi.Checked || chkXoa.Checked)
                    {
                        TUPHAP_NHOMNGUOIDUNG_MENU oT = new TUPHAP_NHOMNGUOIDUNG_MENU();
                        oT.NHOMID = IDNhom;
                        oT.MENUID = IDMenu;
                        oT.XEM = 1;
                        oT.TAOMOI = chkTaomoi.Checked ? 1 : 0;
                        oT.CAPNHAT = chkCapnhat.Checked ? 1 : 0;
                        oT.XOA = chkXoa.Checked ? 1 : 0;
                        oT.NGAYTAO = DateTime.Now;
                        oT.NGUOITAO = Session["UserName"]+"";
                        dt.TUPHAP_NHOMNGUOIDUNG_MENU.Add(oT);
                        dt.SaveChanges();
                    }
                }
                else
                {
                    TUPHAP_NHOMNGUOIDUNG_MENU oT = lst[0];
                    oT.TAOMOI = chkTaomoi.Checked ? 1 : 0;
                    oT.CAPNHAT = chkCapnhat.Checked ? 1 : 0;
                    oT.XOA = chkXoa.Checked ? 1 : 0;
                    oT.XEM = chkXem.Checked ? 1 : 0;

                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
            }
            lstMess.Text =lstMsgB.Text= "Lưu thành công !";
        }

        protected void lblquaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }

        //---------------CHỨC NĂNG-------------------
        protected void chkFullAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;         

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkFull");
                chk.Checked = chkAll.Checked;
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");

                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");

                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                if (chkXem.Enabled)
                    chkXem.Checked = chk.Checked;
                if (chkCapnhat.Enabled)
                    chkCapnhat.Checked = chk.Checked;
                if (chkTaomoi.Enabled)
                    chkTaomoi.Checked = chk.Checked;
                if (chkXoa.Enabled)
                    chkXoa.Checked = chk.Checked;
            }
        }

        protected void chkFull_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkFull = (CheckBox)sender;
          
            decimal ID = Convert.ToDecimal(chkFull.ToolTip);
            TUPHAP_MENU oT = dt.TUPHAP_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                CheckBox chkFullChild = (CheckBox)Item.FindControl("chkFull");
                if (Item.Cells[0].Text.Equals(chkFull.ToolTip))
                {
                    if (chkXem.Enabled)
                        chkXem.Checked = chkFull.Checked;
                    if (chkCapnhat.Enabled)
                        chkCapnhat.Checked = chkFull.Checked;
                    if (chkTaomoi.Enabled)
                        chkTaomoi.Checked = chkFull.Checked;
                    if (chkXoa.Enabled)
                        chkXoa.Checked = chkFull.Checked;
                }
                if (chkFull.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (("/" + oT.ARRSAPXEP + "/").Contains(strSapxep))
                        chkXem.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkCapnhat.Checked = true;
                        chkTaomoi.Checked = true;
                        chkXoa.Checked = true;
                        chkFullChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkXem.Checked = false;
                        chkCapnhat.Checked = false;
                        chkTaomoi.Checked = false;
                        chkXoa.Checked = false;
                        chkFullChild.Checked = false;
                    }
                }
            }
        }

        protected void chkXem_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkXem = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkXem.ToolTip);
            TUPHAP_MENU oT = dt.TUPHAP_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXemChild = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                CheckBox chkFull = (CheckBox)Item.FindControl("chkFull");
                if (chkXem.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (("/" + oT.ARRSAPXEP + "/").Contains(strSapxep))
                        chkXemChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXemChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkFull.Checked = false;
                        chkXemChild.Checked = false;
                        chkCapnhat.Checked = false;
                        chkTaomoi.Checked = false;
                        chkXoa.Checked = false;
                    }
                }
            }
        }

        protected void chkCapnhat_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkCapnhat = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkCapnhat.ToolTip);
            TUPHAP_MENU oT = dt.TUPHAP_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhatChild = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoa = (CheckBox)Item.FindControl("chkXoa");
                if (chkCapnhat.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkCapnhatChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkCapnhatChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkCapnhatChild.Checked = false;
                    }
                }
            }
        }


        protected void chkXoa_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkXoa = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkXoa.ToolTip);
            TUPHAP_MENU oT = dt.TUPHAP_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoi = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoaChild = (CheckBox)Item.FindControl("chkXoa");
                if (chkXoa.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkPheduyetChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkXoaChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkXoaChild.Checked = false;
                    }
                }
            }
        }
        protected void chkTaomoi_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chkTaomoi = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chkTaomoi.ToolTip);
            TUPHAP_MENU oT = dt.TUPHAP_MENU.Where(x => x.ID == ID).FirstOrDefault();
            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chkXem = (CheckBox)Item.FindControl("chkXem");
                CheckBox chkCapnhat = (CheckBox)Item.FindControl("chkCapnhat");
                CheckBox chkTaomoiChild = (CheckBox)Item.FindControl("chkTaomoi");
                CheckBox chkXoaChild = (CheckBox)Item.FindControl("chkXoa");
                if (chkTaomoi.Checked)
                {
                    //Phân quyền lại cấp cha của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    //if (("/" + oT.Sapxep + "/").Contains(strSapxep))
                    //    chkPheduyetChild.Checked = true;
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/") && chkAuto.Checked)
                    {
                        chkXem.Checked = true;
                        chkTaomoiChild.Checked = true;
                    }
                }
                else
                {
                    //Phân quyền lại cấp con của node đang chọn                   
                    string strSapxep = "/" + Item.Cells[1].Text + "/";
                    if (strSapxep.Contains("/" + oT.ARRSAPXEP + "/"))
                    {
                        chkTaomoiChild.Checked = false;
                    }
                }
            }
        }

        protected void chkXemAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkXem");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }

        protected void chkCapnhatAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkCapnhat");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }

        protected void chkTaomoiAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkTaomoi");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }


        protected void chkXoaAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgMenu.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkXoa");
                if (chk.Enabled)
                    chk.Checked = chkAll.Checked;

            }
        }
    }
}