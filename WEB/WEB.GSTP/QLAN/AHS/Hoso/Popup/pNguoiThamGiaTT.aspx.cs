using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.Hoso.Popup
{
    public partial class pNguoiThamGiaTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0, NguoiTGTTID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        String TuCachTT_BiHai_Ma = ENUM_AHS_TUCACHTHAMGIATT.BIHAI;
        Decimal TuCachTT_BiHai_Id = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            if (!IsPostBack)
            {
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
                NguoiTGTTID = (String.IsNullOrEmpty(Request["uID"] + "")) ? 0 : Convert.ToDecimal(Request["uID"] + "");
                hddCurrID.Value = NguoiTGTTID.ToString();
                
                if (VuAnID == 0)
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");

                LoadCombobox();
                if (NguoiTGTTID > 0)
                    LoadInfo();
                uDSNguoiThamGiaToTung.VuAnID = VuAnID;
                CheckTrangThai();
            }
        }
        void CheckTrangThai()
        {
            VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            NgayXayRaVuAn = ((String.IsNullOrEmpty(oT.NGAYXAYRA + "")) || (((DateTime)oT.NGAYXAYRA) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);

            if (oT.MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.DINHCHI)
            {
                lbthongbao.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                LockControl();
                return;
            }
            else if(oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                LockControl();
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                LockControl();
                return;
            }
        }
        void LockControl()
        {
            ddlGioitinh.Enabled = ddlNgheNghiep.Enabled = ddlTuCachTGTT.Enabled = ddlPLTuoi.Enabled= false;
            rdTreViThanhNien.Enabled = false;
            txtNgaysinh.Enabled = txtNamsinh.Enabled = false;
            txtHoten.Enabled = false;
            txtDiaChiChitiet.Enabled = false;
        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlNgheNghiep.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NGHENGHIEP);
            ddlNgheNghiep.DataTextField = "TEN";
            ddlNgheNghiep.DataValueField = "ID";
            ddlNgheNghiep.DataBind();
            ddlNgheNghiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            ddlTuCachTGTT.Items.Clear();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTHS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    ddlTuCachTGTT.Items.Add(new ListItem(row["Ten"] + "", row["ID"].ToString()));
                    if (row["Ma"] + "" == TuCachTT_BiHai_Ma)
                    {
                        TuCachTT_BiHai_Id = Convert.ToDecimal(row["ID"] + "");
                        hddTuCachTT_BiHai_ID.Value = row["ID"] + "";
                    }                
                }
                
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                    pnTreViThanhNien.Visible = true;
                else
                    pnTreViThanhNien.Visible = false;
            }
            else
                ddlTuCachTGTT.Items.Add(new ListItem("--- Chọn ---", "0"));
        }
        protected void txtNgaysinh_TextChanged(object sender, EventArgs e)
        {
            try
            {
                DateTime d = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (d != DateTime.MinValue)
                {
                    txtNamsinh.Text = d.Year.ToString();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
            Cls_Comon.SetFocus(this, this.GetType(), txtNamsinh.ClientID);
        }
        public void LoadInfo()
        {
            decimal ID = Convert.ToDecimal(hddCurrID.Value);
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                int loaidoituong = (String.IsNullOrEmpty(oND.LOAIDT + "")) ? 0 : Convert.ToInt16( oND.LOAIDT);
                Cls_Comon.SetValueComboBox(dropLoaiDoiTuong, loaidoituong);
                if (loaidoituong == 0)
                {
                    //ca nhan
                    lblHoTen.Text = "Họ tên";
                    pnCaNhan.Visible = true;
                    rdTreViThanhNien.SelectedIndex = -1;
                    pnTreViThanhNien.Visible = false;
                    pnNguoiDD.Visible = false;
                }
                else
                {
                    //coquan, to chuc
                    lblHoTen.Text = "Tên " + ((loaidoituong == 1) ? "cơ quan" : "tổ chức");                    
                    pnCaNhan.Visible = false;
                    rdTreViThanhNien.SelectedIndex = -1;
                    pnTreViThanhNien.Visible = false;
                    pnNguoiDD.Visible = true;
                }

                //--------------------
                txtHoten.Text = oND.HOTEN;
                txtDiaChiChitiet.Text = oND.DIACHICHITIET;

                int gioitinh = (String.IsNullOrEmpty(oND.GIOITINH + "")) ? 0 : Convert.ToInt16(oND.GIOITINH);
                if (gioitinh > 1)
                    ddlGioitinh.SelectedIndex = -1;
                else
                    ddlGioitinh.SelectedValue = gioitinh.ToString();
                txtNgaysinh.Text = string.IsNullOrEmpty(oND.NGAYSINH + "") ? "" : ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtNamsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                ddlNgheNghiep.SelectedValue = oND.NGHENGHIEPID.ToString();
                txtNgaythamgia.Text = string.IsNullOrEmpty(oND.NGAYTHAMGIA + "") ? "" : ((DateTime)oND.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
                
                //--------------------
                txtNDD_ChucVu.Text = oND.NDD_CHUCVU + "";
                txtNDD_CMND.Text = oND.NDD_CMND + "";
                txtNDD_Email.Text = oND.NDD_EMAIL + "";
                txtNDD_HoTen.Text = oND.NDD_HOTEN + "";
                txtNDD_Mobile.Text = oND.NDD_MOBILE + "";
                
                //--------------------
                AHS_NGUOITHAMGIATOTUNG_TUCACH tuCach = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == oND.ID).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                if (tuCach != null)
                {
                    TuCachTT_BiHai_Id = Convert.ToDecimal(hddTuCachTT_BiHai_ID.Value);
                    Decimal tucachid = (Decimal)tuCach.TUCACHID;
                    ddlTuCachTGTT.SelectedValue = tucachid + "";
                    if ( tucachid== TuCachTT_BiHai_Id && loaidoituong==0)
                    {
                        pnTreViThanhNien.Visible = true;
                        string isTreVTN = oND.ISTREVITHANHNIEN + "";
                        if (isTreVTN != "")
                        {
                            rdTreViThanhNien.SelectedValue = oND.ISTREVITHANHNIEN.ToString();
                            string isTreViThanhNien = rdTreViThanhNien.SelectedValue;
                            if (isTreViThanhNien == "1")
                            {
                                pnTreVTNCo.Enabled = true;
                                pnTreVTNKhong.Visible = false;
                                ddlPLTuoi.SelectedValue = oND.LOAITREVITHANHNIEN.ToString();
                            }
                            else
                            {
                                pnTreVTNCo.Enabled = false;
                                pnTreVTNKhong.Visible = true;
                            }
                        }
                    }
                    else
                    {
                        rdTreViThanhNien.SelectedValue = "0";
                        pnTreVTNCo.Enabled = false;
                        pnTreVTNKhong.Visible = true;
                    }
                }
                else
                {
                    pnTreViThanhNien.Visible = false;
                }
            }
        }
        protected void rdTreViThanhNien_SelectedIndexChanged(object sender, EventArgs e)
        {
            string isTreViThanhNien = rdTreViThanhNien.SelectedValue;
            if (isTreViThanhNien == "1")
            {
                pnTreVTNCo.Enabled = true;
                pnTreVTNKhong.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), ddlPLTuoi.ClientID);
            }
            else
            {
                pnTreVTNCo.Enabled = false;
                pnTreVTNKhong.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtDiaChiChitiet.ClientID);
            }
        }
        protected void ddlTuCachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if (loaidoituong == 0)
            {
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                    pnTreViThanhNien.Visible = true;
                else
                    pnTreViThanhNien.Visible = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtHoten.ClientID);
        }
        protected void dropLoaiDoiTuong_SelectedIndexChanged(object sender, EventArgs e)
        {
            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if(loaidoituong==0)
            {
                lblHoTen.Text = "Họ tên";
                //ca nhan
                pnCaNhan.Visible = true;
                pnNguoiDD.Visible = false;
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                {
                    rdTreViThanhNien.SelectedIndex = -1;
                    pnTreViThanhNien.Visible = true;
                }
                else
                    pnTreViThanhNien.Visible = false;
            }
            else
            {
                lblHoTen.Text = "Tên " + ((loaidoituong ==1)?"cơ quan":"tổ chức");
                //coquan, to chuc
                pnCaNhan.Visible = false;
                pnNguoiDD.Visible = true;
                rdTreViThanhNien.SelectedIndex = -1;
                pnTreViThanhNien.Visible = false;
            }

            Cls_Comon.SetFocus(this, this.GetType(), txtHoten.ClientID);
        }
        protected void cmdUpdateAndNext_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
                ClearForm();
                lbthongbao.Text = "Cập nhật thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
                ClearForm();
                lbthongbao.Text = "Cập nhật thành công!";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "window.onunload = function (e) {opener.LoadDsNguoiThamGiaTT();};window.close(); ");
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        void SaveData()
        {
            if (!CheckValid()) return;
            VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            NguoiTGTTID = (String.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToDecimal(hddCurrID.Value);

            bool isNew = false;
            AHS_NGUOITHAMGIATOTUNG oND = null;
            if (NguoiTGTTID > 0)
            {
                oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == NguoiTGTTID).FirstOrDefault();
                if (oND != null)
                    isNew = false;
                else
                {
                    isNew = true;
                    oND = new AHS_NGUOITHAMGIATOTUNG();
                }
            }
            else
            {
                isNew = true;
                oND = new AHS_NGUOITHAMGIATOTUNG();
            }

            oND.VUANID = VuAnID;
            oND.HOTEN = txtHoten.Text.Trim();
            oND.DIACHICHITIET = txtDiaChiChitiet.Text.Trim();

            //------
            oND.NGAYSINH = oND.NGAYTHAMGIA = (DateTime?)null;
            oND.NAMSINH = oND.NGHENGHIEPID = 0;
            oND.GIOITINH = (Decimal?)null;
            oND.NDD_HOTEN = oND.NDD_CMND = oND.NDD_MOBILE = oND.NDD_CHUCVU = oND.NDD_EMAIL = "";
            oND.ISTREVITHANHNIEN = oND.LOAITREVITHANHNIEN = 0;

            oND.LOAIDT = Convert.ToDecimal(dropLoaiDoiTuong.SelectedValue);

            if (oND.LOAIDT ==0)
            {
                //ca nhan---
                oND.NGAYSINH = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NAMSINH = txtNamsinh.Text == "" ? 0 : Convert.ToDecimal(txtNamsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);
                oND.NGHENGHIEPID = Convert.ToDecimal(ddlNgheNghiep.SelectedValue);
                oND.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                //TuCach TGTT =  Bị hại 
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                {
                    oND.ISTREVITHANHNIEN = Convert.ToDecimal(rdTreViThanhNien.SelectedValue);
                    string isTreViThanhNien = rdTreViThanhNien.SelectedValue;
                    if (isTreViThanhNien == "1")
                        oND.LOAITREVITHANHNIEN = Convert.ToDecimal(ddlPLTuoi.SelectedValue);
                }
            }
            else
            {
                //-------co quan, to chuc
                oND.NDD_HOTEN = txtNDD_HoTen.Text.Trim();
                oND.NDD_CHUCVU = txtNDD_ChucVu.Text.Trim();
                oND.NDD_CMND = txtNDD_CMND.Text.Trim();
                oND.NDD_MOBILE = txtNDD_Mobile.Text.Trim();
                oND.NDD_EMAIL = txtNDD_Email.Text.Trim();
            }
           
            // Đây là giai đoạn lập hồ sơ vụ án nên ISHOSO= 1
            oND.ISHOSO = 1;
            if (isNew)
            {
                if (oND.TOA_GIAIQUYET_ID == null)
                {
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_NGUOITHAMGIATOTUNG.Add(oND);
            }

            dt.SaveChanges();
            NguoiTGTTID = oND.ID;
            try
            {
                UpdateTuCach(NguoiTGTTID);
            }
            catch (Exception ex) { }

            hddIsReloadParent.Value = "1";
        }
        void ClearForm()
        {
            dropLoaiDoiTuong.SelectedIndex = 0;
            ddlTuCachTGTT.SelectedIndex = 0;

            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if (loaidoituong == 0)
            {
                pnNguoiDD.Visible = false;
                pnCaNhan.Visible = true;
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                    pnTreViThanhNien.Visible = true;
                else
                    pnTreViThanhNien.Visible = false;
                rdTreViThanhNien.SelectedIndex = -1;
                ddlPLTuoi.SelectedIndex = 0;
                pnTreVTNCo.Enabled = false;
            }

            txtHoten.Text = txtNamsinh.Text = txtNgaysinh.Text = "";
            txtDiaChiChitiet.Text = txtNgaythamgia.Text = "";
            ddlGioitinh.SelectedIndex = 0;
            ddlNgheNghiep.SelectedValue = "0";

            txtNDD_ChucVu.Text = txtNDD_CMND.Text = "";
            txtNDD_Email.Text = txtNDD_HoTen.Text = txtNDD_Mobile.Text = "";

            hddCurrID.Value = "0";
            lbthongbao.Text = "";
            Cls_Comon.SetFocus(this, this.GetType(), dropLoaiDoiTuong.ClientID);
        }
        private void UpdateTuCach(Decimal NguoiThamGiaID)
        {
            bool isNew = false;
            AHS_NGUOITHAMGIATOTUNG_TUCACH obj = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == NguoiThamGiaID).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
            if (obj == null)
            {
                obj = new AHS_NGUOITHAMGIATOTUNG_TUCACH();
                isNew = true;
            }
            obj.NGUOIID = NguoiThamGiaID;
            obj.TUCACHID = Convert.ToDecimal(ddlTuCachTGTT.SelectedValue);
            if (isNew)
                dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(obj);
            dt.SaveChanges();
        }
        private bool CheckValid()
        {
            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if (loaidoituong == 0)
            {
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                {
                        if (rdTreViThanhNien.SelectedValue == "")
                        {
                            lbthongbao.Text = "Mục 'Trẻ vị thành niên' bắt buộc phải chọn. Hãy kiểm tra lại.";
                            return false;
                        }
                  }
            }
            return true;
        }
    }
}