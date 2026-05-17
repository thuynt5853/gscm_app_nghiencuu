using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc
{
    public partial class Danhmucngaynghi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGrid();
                txtNam.Text = DateTime.Now.Year.ToString();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            DM_NGAYNGHI obj = new DM_NGAYNGHI();
            lbthongbao.Text = "";
            if (string.IsNullOrEmpty(txtNgayNghi.Text))
            {
                lbthongbao.Text = "Vui lòng nhập ngày";
                return;
            }
            DateTime NgayNghi = DateTime.Parse(txtNgayNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (hddid.Value == "" || hddid.Value == "0")
            {
                int countthem = dt.DM_NGAYNGHI.Where(x => x.NGAYNGHI.Value.Day== NgayNghi.Day && x.NGAYNGHI.Value.Month== NgayNghi.Month && x.NGAYNGHI.Value.Year==NgayNghi.Year).ToList().Count;
                if (countthem > 0)
                {
                    lbthongbao.Text = "Ngày nghỉ đã tồn tại!";
                }
                else
                {

                    obj.NGAYNGHI = NgayNghi;
                    obj.NAM = Convert.ToDecimal(txtNam.Text);
                    obj.MOTA = txtMoTa.Text;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYTAO = DateTime.Now;
                    dt.DM_NGAYNGHI.Add(obj);
                    dt.SaveChanges();
                    lbthongbao.Text = "Thêm mới thành công!";
                }
            }
            else
            { //sua
                //lấy ra thông tin theo cái id vần sửa
                decimal _id = Convert.ToDecimal(hddid.Value);
                obj = dt.DM_NGAYNGHI.Where(x => x.ID == _id).FirstOrDefault();
                if (obj == null) return;


                obj.NGAYNGHI = NgayNghi;

                obj.MOTA = txtMoTa.Text;
                obj.NAM = Convert.ToDecimal(txtNam.Text);
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                obj.NGAYSUA = DateTime.Now;
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
            List<DM_NGAYNGHI> lst = dt.DM_NGAYNGHI.ToList();
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
            hddid.Value = 0+"";
            txtNgayNghi.Text = "";
            txtMoTa.Text = "";
            
        }
        public void xoa(decimal id)
        {

            DM_NGAYNGHI oT = dt.DM_NGAYNGHI.Where(x => x.ID == id).FirstOrDefault();
            dt.DM_NGAYNGHI.Remove(oT);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            Resetcontrol();
            lbthongbao.Text = "Xóa thành công!";
        }

        public void loadedit(decimal ID)
        {
            DM_NGAYNGHI oT = dt.DM_NGAYNGHI.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            txtNgayNghi.Text = oT.NGAYNGHI.Value.ToString("dd/MM/yyyy");
            txtMoTa.Text = oT.MOTA;
            txtNam.Text = oT.NAM+"";
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
    }
}