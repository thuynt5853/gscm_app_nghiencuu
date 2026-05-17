using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace WEB.GSTP.Danhmuc.Nhomdanhmuc
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGrid();
                LoadLoaiDM();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
               
            }
        }
        public void LoadLoaiDM()
        {
            dropLoaiDM.Items.Clear();

            dropLoaiDM.Items.Insert(0, new ListItem("Đơn cấp", "1"));
            dropLoaiDM.Items.Insert(1, new ListItem("Đa cấp", "2"));
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            DM_DATAGROUP obj=new DM_DATAGROUP();
            lbthongbao.Text = ""; ;
            if (hddid.Value == "" || hddid.Value == "0")
            {
                int countthem = dt.DM_DATAGROUP.Where(x => x.MA == txtMa.Text.Trim()).ToList().Count;
                if (countthem > 0)
                {
                    lbthongbao.Text = "Mã nhóm danh mục đã tồn tại!";
                }
                else
                {

                    obj.TEN = txtTen.Text.Trim(); ;
                    obj.MA = txtMa.Text.Trim();
                    obj.LOAI = Convert.ToDecimal(dropLoaiDM.SelectedValue);
                    obj.GHICHU = txtGhiChu.Text.Trim();
                    obj.NGAYTAO = DateTime.Now;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.DM_DATAGROUP.Add(obj);
                    dt.SaveChanges();
                    lbthongbao.Text = "Thêm mới thành công!";
                }
            }
            else
            { //sua
                //lấy ra thông tin theo cái id vần sửa
                decimal _id = Convert.ToDecimal(hddid.Value);
                obj = dt.DM_DATAGROUP.Where(x => x.ID == _id).FirstOrDefault();
                if (obj == null) return;


                obj.TEN = txtTen.Text.Trim();

                obj.LOAI = Convert.ToDecimal(dropLoaiDM.SelectedValue);
                obj.GHICHU = txtGhiChu.Text.Trim();
                dt.SaveChanges();
                hddid.Value = _id + "";
                Resetcontrol();
                lbthongbao.Text = "Lưu thành công!";



            }
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            Resetcontrol();
        }
        public void LoadGrid()
        {
            List<DM_DATAGROUP> lst = dt.DM_DATAGROUP.Where(x=>x.MA==txttimkiem.Text || x.TEN.Contains(txttimkiem.Text)).ToList();
            if (lst != null && lst.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(lst.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + lst.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = lst;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }
        protected void Resetcontrol()
        {
            hddid.Value = hddGUID.Value;
            txtTen.Text = "";
            txtMa.Text = "";
            txtGhiChu.Text = "";
            dropLoaiDM.SelectedIndex = 0;
            txtMa.Enabled = true;
        }
        public void xoa(decimal id)
        {
          
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x=>x.GROUPID== id).ToList();
            if (lst.Count > 0)
            {
                lbthongbao.Text = "Nhóm danh mục đã có dữ liệu, không thể xóa được.";
                return;
            }
            DM_DATAGROUP oT = dt.DM_DATAGROUP.Where(x=>x.ID==id).FirstOrDefault();
            dt.DM_DATAGROUP.Remove(oT);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            Resetcontrol();
            lbthongbao.Text = "Xóa thành công!";
        }
     
        public void loadedit(decimal ID)
        {
            DM_DATAGROUP oT = dt.DM_DATAGROUP.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            txtTen.Text = oT.TEN;
            txtMa.Text = oT.MA;
            txtMa.Enabled = false;
            txtGhiChu.Text = oT.GHICHU;
            dropLoaiDM.SelectedValue = Convert.ToString(oT.LOAI);
        }
        string s = "";
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal donvi_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    loadedit(donvi_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(donvi_id);
                    Resetcontrol();

                    break;
            }

        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion

        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            LoadGrid();
        }

    }
}
