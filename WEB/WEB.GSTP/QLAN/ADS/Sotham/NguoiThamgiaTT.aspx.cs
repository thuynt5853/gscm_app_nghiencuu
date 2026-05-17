using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.ADS.Sotham
{
    public partial class NguoiThamgiaTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");
                LoadCombobox();
                LoadTGTTFromDonKK();
                LoadGrid();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdChonTGTT, oPer.CAPNHAT);
                decimal ID = Convert.ToDecimal(current_id);
                ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdChonTGTT, false);
                    return;
                }
                //check vụ án đã kết thúc không cho sửa xóa
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    return;
                }
            }
        }

        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
           
            ddlTucachTGTT.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTDS);
            ddlTucachTGTT.DataTextField = "TEN";
            ddlTucachTGTT.DataValueField = "MA";
            ddlTucachTGTT.DataBind();
        }

        private void LoadTGTTFromDonKK()
        {
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ADS_DON_BL oBL = new ADS_DON_BL();
            chkListTGTT.DataSource = oBL.ADS_DON_TGTT_GETLIST(DONID);
            chkListTGTT.DataTextField = "arrTEN";
            chkListTGTT.DataValueField = "ID";
            chkListTGTT.DataBind();
        }

        private void ResetControls()
        {
            txtHoten.Text = "";
            txtNDD_Hoten.Text = txtNDD_Chucvu.Text= "";
            txtND_Ngaysinh.Text = "";
            txtND_Thangsinh.Text = "";
            txtND_Namsinh.Text = "";
            txtND_HKTT.Text = txtND_HKTT_Chitiet.Text = "";
            txtND_TTMA.Text = txtND_TTChitiet.Text = "";          
            hddND_HKTTID.Value = hdd_ND_TramtruID.Value = "0";
            txtNgaythamgia.Text = txtNgayketthuc.Text = "";
            hddid.Value = "0";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }

        private bool CheckValid()
        {
            if (txtHoten.Text == "")
            {
                lbthongbao.Text = "Chưa nhập tên người tham gia tố tụng";
                return false;
            }         
           
                if (hdd_ND_TramtruID.Value == "")
                {
                    lbthongbao.Text = "Chưa chọn nơi đăng ký tạm trú";
                    return false;
                }
          
            return true;
        }

        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtND_Thangsinh.Text = d.Month.ToString();
                txtND_Namsinh.Text = d.Year.ToString();
                txtNDD_Hoten.Focus();
            }
        }

        protected void cmdChonTGTT_Click(object sender, EventArgs e)
        {
            bool flag = false;
            foreach(ListItem oItem in chkListTGTT.Items)
            {
                if(oItem.Selected)
                {
                    flag = true;
                    decimal NID = Convert.ToDecimal(oItem.Value);
                    if (dt.ADS_SOTHAM_THAMGIATOTUNG.Where(x => x.NTGTT_DONKK_ID == NID).ToList().Count == 0)
                    {
                        ADS_DON_THAMGIATOTUNG oD = dt.ADS_DON_THAMGIATOTUNG.Where(x => x.ID == NID).FirstOrDefault();
                        ADS_SOTHAM_THAMGIATOTUNG oS = new ADS_SOTHAM_THAMGIATOTUNG();
                        oS.DONID = oD.DONID;
                        oS.HOTEN = oD.HOTEN;
                        oS.TUCACHTGTTID = oD.TUCACHTGTTID;
                        oS.TAMTRUID = oD.TAMTRUID;
                        oS.TAMTRUCHITIET = oD.TAMTRUCHITIET;
                        oS.HKTTID = oD.HKTTID;
                        oS.HKTTCHITIET = oD.HKTTCHITIET;
                        oS.NGAYSINH = oD.NGAYSINH;
                        oS.THANGSINH = oD.THANGSINH;
                        oS.NAMSINH = oD.NAMSINH;
                        oS.GIOITINH = oD.GIOITINH;
                        oS.NGUOIDAIDIEN = oD.NGUOIDAIDIEN;
                        oS.CHUCVU = oD.CHUCVU;
                        oS.NGAYTHAMGIA = oD.NGAYTHAMGIA;
                        oS.NGAYKETTHUC = oD.NGAYKETTHUC;
                        oS.NGAYTAO = DateTime.Now;
                        oS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oS.NTGTT_DONKK_ID = oD.ID;
                        dt.ADS_SOTHAM_THAMGIATOTUNG.Add(oS);
                        dt.SaveChanges();
                    }
                }
            }
            if(flag)
            {
                lblMsgChon.Text = "Lưu thành công !";
                LoadGrid();
            }
            else
            {
                lblMsgChon.Text = "Chưa chọn người tham gia tố tụng !";
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                ADS_SOTHAM_THAMGIATOTUNG oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new ADS_SOTHAM_THAMGIATOTUNG();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.ADS_SOTHAM_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.HOTEN = txtHoten.Text;             
                oND.TUCACHTGTTID =ddlTucachTGTT.SelectedValue;              
                oND.TAMTRUID = hdd_ND_TramtruID.Value == "" ? 0 : Convert.ToDecimal(hdd_ND_TramtruID.Value);
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.HKTTID = hddND_HKTTID.Value == "" ? 0 : Convert.ToDecimal(hddND_HKTTID.Value);
                oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                oND.NGAYSINH = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.THANGSINH = txtND_Thangsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Thangsinh.Text);
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = txtNDD_Hoten.Text;
                oND.CHUCVU = txtNDD_Chucvu.Text;

                oND.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKETTHUC = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.ADS_SOTHAM_THAMGIATOTUNG.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    dt.SaveChanges();
                }
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        public void LoadGrid()
        {
            ADS_SOTHAM_BL oBL = new ADS_SOTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.ADS_SOTHAM_TGTT_GETLIST(ID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
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
            ResetControls();
        }

        public void xoa(decimal id)
        {

            ADS_SOTHAM_THAMGIATOTUNG oND = dt.ADS_SOTHAM_THAMGIATOTUNG.Where(x => x.ID == id).FirstOrDefault();
          
            dt.ADS_SOTHAM_THAMGIATOTUNG.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }

        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            ADS_SOTHAM_THAMGIATOTUNG oND = dt.ADS_SOTHAM_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            txtHoten.Text = oND.HOTEN;
            ddlTucachTGTT.SelectedValue = oND.TUCACHTGTTID.ToString();           
            if (oND.TAMTRUID != null) txtND_TTMA.Text = oHCBL.GetTextByID((decimal)oND.TAMTRUID);
            hdd_ND_TramtruID.Value = oND.TAMTRUID.ToString();
            txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
            if (oND.HKTTID != null) txtND_HKTT.Text = oHCBL.GetTextByID((decimal)oND.HKTTID);
            hddND_HKTTID.Value = oND.HKTTID.ToString();
            txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
            if (oND.NGAYSINH != null) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
            txtND_Thangsinh.Text = oND.THANGSINH == 0 ? "" : oND.THANGSINH.ToString();
            txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            txtNDD_Hoten.Text = oND.NGUOIDAIDIEN;
            txtNDD_Chucvu.Text = oND.CHUCVU;

            if (oND.NGAYTHAMGIA!= null) txtNgaythamgia.Text = ((DateTime)oND.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
            if (oND.NGAYKETTHUC!= null) txtNgayketthuc.Text = ((DateTime)oND.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();

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

        protected void rdbLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(rdbLoai.SelectedValue=="0")
            {
                pnNew.Visible = true;
                pnChon.Visible = false;
            }
            else
            {
                pnNew.Visible = false;
                pnChon.Visible = true;
            }
        }
    }
}