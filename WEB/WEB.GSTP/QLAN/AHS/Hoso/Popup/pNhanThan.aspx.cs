using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
//using BL.GSTP.AHS;

using System.Globalization;
using Module.Common;
using BL.GSTP.AHS;

namespace WEB.GSTP.QLAN.AHS.Hoso.Popup
{
    public partial class pNhanThan : System.Web.UI.Page
    {
        public Decimal VuAnID = 0, BiCanID = 0, QuocTichVN=0;
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
            BiCanID = (String.IsNullOrEmpty(Request["bID"] + "")) ? 0 : Convert.ToDecimal(Request["bID"] + "");

            if (!IsPostBack)
            {
                LoadComboBox();
                if (Request["type"] != null)
                    dropMoiQuanHe.SelectedValue = Request["type"];

                uDsNhanThanBiCao.VuAnID = VuAnID;
                uDsNhanThanBiCao.BiCanID = BiCanID;
                uDsNhanThanBiCao.ShowAll = 1;

                if (Request["uID"] != null)
                    LoadInfo(Convert.ToDecimal(Request["uID"] + ""));
                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lstMsgB.Text = Result;
                    Cls_Comon.SetButton(cmdUpdate, false);
                    return;
                }
            }
        }
        void CheckTrangThai()
        {
            VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                LockControl();
                return;
            }
        }
        void LockControl()
        {
            txtHoTen.Enabled = false;
            ddlGioitinh.Enabled = dropMoiQuanHe.Enabled = false;
            txtNamSinh.Enabled = txtGhiChu.Enabled = txtDiaChi.Enabled = false;
        }
        void LoadComboBox()
        {
            //dropMoiQuanHe.Items.Clear();
            //Decimal MoiQuanHeNhanThanID = 0;
            //string QHNhanThan = ENUM_QH_NHANTHAN.CON;
            //try { MoiQuanHeNhanThanID = dt.DM_DATAITEM.Where(x => x.MA == QHNhanThan).FirstOrDefault().ID; } catch (Exception ex) { }
            //dropMoiQuanHe.Items.Add(new ListItem("Con", MoiQuanHeNhanThanID.ToString()));
            dropMoiQuanHe.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QH_NHAN_THAN);            
            if (tbl != null && tbl.Rows.Count > 0)
            {
                String Ma = "";
                foreach (DataRow row in tbl.Rows)
                {
                    Ma = row["Ma"] + "";
                    if (Ma == ENUM_QH_NHANTHAN.BO || Ma == ENUM_QH_NHANTHAN.ME 
                        || Ma == ENUM_QH_NHANTHAN.VO_CHONG || Ma == ENUM_QH_NHANTHAN.CON )
                        dropMoiQuanHe.Items.Add(new ListItem(row["Ten"] + "", row["Ma"] + ""));
                }
            }
        }
        private void LoadInfo(decimal NhanThanID)
        {
            AHS_BICAN_NHANTHAN obj = null;
            try
            {
                obj = dt.AHS_BICAN_NHANTHAN.Where(x => x.ID == NhanThanID).SingleOrDefault();
            }
            catch (Exception ex) { obj = null; }

            if (obj != null)
            {
                txtHoTen.Text = obj.HOTEN;
                ddlGioitinh.SelectedValue = (string.IsNullOrEmpty(obj.GIOITINH + "")) ? "0" : obj.GIOITINH + "";
                dropMoiQuanHe.SelectedValue = (string.IsNullOrEmpty(obj.MOIQUANHEID + "")) ? "0" : obj.MOIQUANHEID + "";

                txtDiaChi.Text = obj.HKTT_CHITIET + "";
                txtGhiChu.Text = obj.GHICHU;
                //-------------------------------------
                txtNamSinh.Text = (string.IsNullOrEmpty(obj.NGAYSINH_NAM+""))?"": obj.NGAYSINH_NAM + "";
                ddlGioitinh.SelectedValue = obj.GIOITINH.ToString();
            }
        }

        //-----------------------------
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            Boolean IsUpdate = false;
            Decimal MoiQuanHeID = (decimal)dt.DM_DATAITEM.SingleOrDefault(x=>x.MA == dropMoiQuanHe.SelectedValue).ID;
            AHS_BICAN_NHANTHAN obj = new AHS_BICAN_NHANTHAN();
            String hoten = txtHoTen.Text.Trim().ToLower();
            Decimal namsinh = Convert.ToDecimal(txtNamSinh.Text);
            try
            {
                if (BiCanID > 0)
                {
                    if (dropMoiQuanHe.SelectedValue != ENUM_QH_NHANTHAN.CON)
                    {
                        obj = dt.AHS_BICAN_NHANTHAN.Where(x => x.BICANID == BiCanID
                                                              && x.VUANID == VuAnID
                                                              && x.MOIQUANHEID == MoiQuanHeID
                                                            ).Single<AHS_BICAN_NHANTHAN>();
                        IsUpdate = true;
                    }
                    else
                    {
                        List<AHS_BICAN_NHANTHAN> lsNT = dt.AHS_BICAN_NHANTHAN.Where(x => x.BICANID == BiCanID && x.VUANID == VuAnID 
                                                                                      && x.MOIQUANHEID == MoiQuanHeID
                                                                                      && x.NGAYSINH_NAM == namsinh
                                                                                      && x.HOTEN.ToLower() ==  hoten ).ToList();
                        if (lsNT != null && lsNT.Count > 0)
                        {
                            obj = lsNT[0];
                            IsUpdate = true;
                        }
                    }
                }
                else
                    obj = new AHS_BICAN_NHANTHAN();
            }
            catch (Exception ex) { obj = new AHS_BICAN_NHANTHAN(); }
                hoten = Cls_Comon.FormatTenRieng(txtHoTen.Text.Trim());
                obj.VUANID = VuAnID;
                obj.BICANID = BiCanID;
                obj.MOIQUANHEID = MoiQuanHeID;            
                obj.HOTEN = hoten;               
                obj.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);            
                obj.NGAYSINH_NAM = namsinh;               
                obj.HKTT_CHITIET = txtDiaChi.Text;
                obj.GHICHU = txtGhiChu.Text;
            //--------------------------------
            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.AHS_BICAN_NHANTHAN.Add(obj);
                dt.SaveChanges();
            }
                
            Cls_Comon.ShowMsgAnClosePopup(this, this.GetType(), "Lưu dữ liệu thành công!");
        }
    }
}