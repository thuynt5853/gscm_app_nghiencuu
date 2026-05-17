using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;
using BL.GSTP.THA;
using BL.GSTP.AHS;

namespace WEB.GSTP.QLAN.THA.HoSo
{
    public partial class DanhsachBiCanBA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        //CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal CurrUserID = 0, ToaAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadDropLoai();
                    LoadGrid();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        void LoadVuAn(decimal loai, string idVuAn)
        {
            txtSoBanAn.Text = Session[ENUM_THA_VUAN.SESSION_BA_ST_SO].ToString();
            txtNgayBanAn.Text = Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN].ToString();
            decimal vuanID = Convert.ToDecimal(idVuAn);
            if(loai == 1)
            {
                AHS_VUAN tVA = dt.AHS_VUAN.Where(x => x.ID == vuanID).FirstOrDefault();
                txtTenVuAn.Text = tVA.TENVUAN;
                txtToaAn.Text = dt.DM_TOAAN.Where(x => x.ID == tVA.TOAANID).FirstOrDefault().TEN;
            }
            else
            {
                THA_VUAN tVA = dt.THA_VUAN.Where(x => x.ID == vuanID).FirstOrDefault();
                txtTenVuAn.Text = tVA.BA_TENVUAN;
                txtToaAn.Text = dt.DM_TOAAN.Where(x => x.ID == tVA.TOAANID).FirstOrDefault().TEN;
            }
            txtSoBanAn.Enabled = txtNgayBanAn.Enabled = txtTenVuAn.Enabled = txtToaAn.Enabled = false;
        }
        void LoadDropLoai()
        {
            dropLoaiLuaChon.Items.Clear();
            dropLoaiLuaChon.Items.Add(new ListItem("Thuộc hệ thống quản lý án", "1"));
            dropLoaiLuaChon.Items.Add(new ListItem("Ngoài hệ thống quản lý án", "2"));
        }

        public void LoadGrid()
        {
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            string mavuan ="";
            string tenvuan = "";
            string mabian = "";
            string tenbian = "";
            string sobanan = Session[ENUM_THA_VUAN.SESSION_BA_ST_SO].ToString();
            DateTime ngaybanan = Convert.ToDateTime(Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN]);
            decimal loai = Convert.ToDecimal(dropLoaiLuaChon.SelectedValue);
            THA_BIAN_BL objBL = new THA_BIAN_BL();
            DataTable tbl = null;
            pnVA.Visible = false;
            if (loai == 1)
            {
                tbl = objBL.GetAnHSTrongHeThongChonBiAn(ToaAnID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, pageindex, page_size);
            }
            else
            {                
                tbl = objBL.GetAnHSNgoaiHeThongChonBiAn(ToaAnID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, pageindex, page_size);
            }                

            if (tbl != null && tbl.Rows.Count > 0)
            {
                pnVA.Visible = true;
                string vuanID = loai == 1 ? tbl.Rows[0]["IDVuAnHeThong"] + "" : tbl.Rows[0]["VuAnID"] + "";
                LoadVuAn(loai, vuanID);
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                int all_page = Cls_Comon.GetTotalPage(count_all, page_size);
                hddTotalPage.Value = all_page.ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                rpt.Visible = true;
                rpt.DataSource = tbl;
                rpt.DataBind();
            }
            else
            {
                rpt.Visible = false;
                // lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }


        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }
        #endregion
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string StrPara = "";
            string[] arr = null;
            decimal IDUser = 0;
            decimal bian_id = 0, vuan_id = 0, IDVuAnHeThong = 0;
            string IDVUAN = "";
            QT_NGUOISUDUNG oNSD = null;
            lbtthongbao.Text = "";
            switch (e.CommandName)
            {
                case "ThuLyAn":
                    StrPara = e.CommandArgument.ToString();
                    if (StrPara.Contains("$"))
                    {
                        arr = StrPara.Split('$');
                        bian_id = Convert.ToDecimal(arr[0] + "");
                        THA_BIAN tBA = dt.THA_BIAN.Where(x => x.IDBICANHETHONG == bian_id).FirstOrDefault();
                        if (tBA != null)
                        {
                            THA_THULY tTL = dt.THA_THULY.Where(x => x.BIANID == tBA.ID).FirstOrDefault();
                            if (tTL != null)
                            {
                                lbtthongbao.Text = "Bị án đã có thông tin thụ lý!";
                                return;
                            }
                        }
                        else
                        {
                            THA_THULY tTL = dt.THA_THULY.Where(x => x.BIANID == bian_id).FirstOrDefault();
                            if (tTL != null)
                            {
                                lbtthongbao.Text = "Bị án đã có thông tin thụ lý!";
                                return;
                            }
                        }
                        hddBiAnID.Value = bian_id.ToString();
                        IDVuAnHeThong = Convert.ToDecimal(arr[1] + "");
                    }
                    if (IDVuAnHeThong > 0)
                        Them_ThuLyBiAn(IDVuAnHeThong, bian_id);

                    //----------Chon bi an can cap nhat thong tin----------
                    //Lưu vào người dùng
                    

                    IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    oNSD.IDTHA = Convert.ToDecimal(hddBiAnID.Value);//luu thong tin id bi an vao
                    dt.SaveChanges();

                    Session[ENUM_LOAIAN.AN_THA] = oNSD.IDTHA;
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    
                    break;
            }
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
        }

        protected void dropLoaiLuaChon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            { }
        }

        void Them_ThuLyBiAn(Decimal IDVuAnHeThong, decimal bian_id)
        {
            Boolean IsNew_VuAn = true, IsNew_BiAn = true;
            Decimal THA_VuAnID = 0;
            THA_VUAN objVA = null;
            THA_BIAN objBA = null;
            try
            {
                objVA = dt.THA_VUAN.Where(x => x.IDVUANHETHONG == IDVuAnHeThong).Single<THA_VUAN>();
                if (objVA == null)
                {
                    objVA = new THA_VUAN();
                    objBA = new THA_BIAN();
                }
                else
                {
                    IsNew_VuAn = false;
                    THA_VuAnID = objVA.ID;
                    //----------------------
                    if (objVA.ISHETHONG == 1)
                    {
                        try
                        {
                            objBA = dt.THA_BIAN.Where(x => x.VUANID == THA_VuAnID && x.IDBICANHETHONG == bian_id).Single<THA_BIAN>();
                            if (objBA != null)
                            {
                                IsNew_BiAn = false;
                                hddBiAnID.Value = objBA.ID.ToString();
                            }
                            else
                                objBA = new THA_BIAN();
                        }
                        catch (Exception ex) { objBA = new THA_BIAN(); }
                    }
                    else
                    {
                        try
                        {
                            objBA = dt.THA_BIAN.Where(x => x.ID == bian_id).Single<THA_BIAN>();
                            if (objBA != null)
                            {
                                IsNew_BiAn = false;
                                hddBiAnID.Value = objBA.ID.ToString();
                            }
                            else
                                objBA = new THA_BIAN();
                        }
                        catch (Exception ex) { objBA = new THA_BIAN(); }
                    }

                }
            }
            catch (Exception ex)
            {
                objVA = new THA_VUAN();
                objBA = new THA_BIAN();
            }
            if (IsNew_VuAn)
            {
                //Them thong tin vu an vao THA_VuAn
                objVA.IDVUANHETHONG = IDVuAnHeThong;
                THA_VuAnID = Them_VuAn_TrongHeThongQLA(IDVuAnHeThong, objVA);
            }
            //--------------------
            if (IsNew_BiAn)
            {
                //them thong tin bi an vao THA_BiAn voi VuAnID = THA_VuAnID
                objBA.VUANID = THA_VuAnID;
                objBA.IDBICANHETHONG = bian_id;
                Them_BiAn_TrongHeThongQLA(bian_id, IDVuAnHeThong, objBA);
            }
        }
        Decimal Them_VuAn_TrongHeThongQLA(decimal vuan_hethong_id, THA_VUAN objva)
        {
            AHS_VUAN_BL objBL = new AHS_VUAN_BL();
            DataTable tbl = objBL.GetThongTin(vuan_hethong_id);
            if (tbl != null && tbl.Rows.Count == 1)
            {
                DataRow row = tbl.Rows[0];
                objva.ISHETHONG = 1;
                objva.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                objva.BA_MAVUAN = row["MAVUAN"] + "";
                objva.BA_TENVUAN = row["TENVUAN"] + "";
                objva.BA_NGAYVUAN = (String.IsNullOrEmpty(row["NgayVuAn"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["NgayVuAn"] + "");
                objva.BA_THANG = String.IsNullOrEmpty(row["NgayVuAn_Thang"] + "") ? 0 : Convert.ToDecimal(row["NgayVuAn_Thang"] + "");
                objva.BA_NAM = String.IsNullOrEmpty(row["NgayVuAn_Nam"] + "") ? 0 : Convert.ToDecimal(row["NgayVuAn_Nam"] + "");
                objva.BA_TINHCHAT = String.IsNullOrEmpty(row["TinhChatVA"] + "") ? 0 : Convert.ToDecimal(row["TinhChatVA"] + "");
                //-----------------
                objva.BA_ST_SO = row["ST_SoBanAn"] + "";
                objva.BA_ST_NGAYBANAN = (String.IsNullOrEmpty(row["ST_NgayBanAn"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["ST_NgayBanAn"] + "");
                objva.BA_ST_NGAYHIEULUC = (String.IsNullOrEmpty(row["ST_NgayHieuLuc"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["ST_NgayHieuLuc"] + "");
                objva.BA_ST_TOAANID = (String.IsNullOrEmpty(row["ST_ToaAnID"] + "")) ? 0 : Convert.ToDecimal(row["ST_ToaAnID"] + "");
                //-----------------
                objva.BA_PT_SO = row["PT_SoBanAn"] + "";
                objva.BA_PT_NGAYBANAN = (String.IsNullOrEmpty(row["PT_NgayBanAn"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["PT_NgayBanAn"] + "");
                objva.BA_PT_NGAYHIEULUC = (String.IsNullOrEmpty(row["PT_NgayHieuLuc"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["PT_NgayHieuLuc"] + "");
                objva.BA_PT_TOAANID = (String.IsNullOrEmpty(row["PT_ToaAnID"] + "")) ? 0 : Convert.ToDecimal(row["PT_ToaAnID"] + "");

                //-----------
                objva.NGAYTAO = DateTime.Now;
                objva.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                objva.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_VUAN.Add(objva);
                dt.SaveChanges();
                return objva.ID;
            }
            else return 0;
        }
        void Them_BiAn_TrongHeThongQLA(Decimal bian_hethong_id, decimal vuan_hethong_id, THA_BIAN objBA)
        {
            AHS_BICANBICAO obj = dt.AHS_BICANBICAO.Where(x => x.ID == bian_hethong_id).Single<AHS_BICANBICAO>();
            if (obj != null)
            {
                objBA.IDBICANHETHONG = bian_hethong_id;
                objBA.IDVUANHETHONG = vuan_hethong_id;

                objBA.BICANDAUVU = obj.BICANDAUVU;
                objBA.MABICAN = obj.MABICAN;

                objBA.HOTEN = obj.HOTEN;
                objBA.TENKHAC = obj.TENKHAC;
                objBA.NGAYSINH = obj.NGAYSINH;
                objBA.THANGSINH = obj.THANGSINH;
                objBA.NAMSINH = obj.NAMSINH;
                objBA.SOCMND = obj.SOCMND;

                objBA.TRINHDOVANHOAID = obj.TRINHDOVANHOAID;
                objBA.NGHENGHIEPID = obj.NGHENGHIEPID;

                objBA.DANTOCID = obj.DANTOCID;
                objBA.QUOCTICHID = obj.QUOCTICHID;

                objBA.GIOITINH = obj.GIOITINH;
                objBA.TONGIAOID = obj.TONGIAOID;

                objBA.NGAYTHAMGIA = obj.NGAYTHAMGIA;

                objBA.HKTT = obj.HKTT;
                objBA.HKTT_HUYEN = obj.HKTT_HUYEN;
                objBA.KHTTCHITIET = obj.KHTTCHITIET;

                objBA.TAMTRU = obj.TAMTRU;
                objBA.TAMTRU_HUYEN = obj.TAMTRU_HUYEN;
                objBA.TAMTRUCHITIET = obj.TAMTRUCHITIET;

                objBA.CHUCVUCHINHQUYENID = obj.CHUCVUCHINHQUYENID;
                objBA.CHUCVUDANGID = obj.CHUCVUDANGID;
                objBA.TINHTRANGGIAMGIUID = obj.TINHTRANGGIAMGIUID;

                objBA.NGHIENHUT = obj.NGHIENHUT;
                objBA.TAIPHAM = obj.TAIPHAM;

                objBA.TIENAN = obj.TIENAN;
                objBA.TIENSU = obj.TIENSU;

                objBA.TREMOCOI = obj.TREMOCOI;
                objBA.BOMELYHON = obj.BOMELYHON;
                objBA.TREBOHOC = obj.TREBOHOC;
                objBA.TRELANGTHANG = obj.TRELANGTHANG;
                objBA.CONGUOIXUIGIUC = obj.CONGUOIXUIGIUC;
                objBA.NGHIENHUT = obj.NGHIENHUT;

                objBA.ISTREVITHANHNIEN = obj.ISTREVITHANHNIEN;
                objBA.LOAIDOITUONG = obj.LOAIDOITUONG;

                objBA.NGAYTAO = DateTime.Now;
                objBA.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                //----------------
                #region Thong tin nhan than : Bo , Me
                AHS_BICAN_NHANTHAN_BL objNT = new AHS_BICAN_NHANTHAN_BL();
                DataTable tblNT = objNT.GetByVuAn_BiAnID(vuan_hethong_id, bian_hethong_id);
                string MaMoiQH = "";
                if (tblNT != null && tblNT.Rows.Count > 0)
                {
                    foreach (DataRow item in tblNT.Rows)
                    {
                        MaMoiQH = item["MaMoiQH"] + "";
                        switch (MaMoiQH)
                        {
                            case ENUM_QH_NHANTHAN.BO:
                                objBA.HOTENBO = item["HoTen"] + "";
                                objBA.NAMSINHBO = String.IsNullOrEmpty(item["Ngaysinh_nam"] + "") ? 0 : Convert.ToDecimal(item["Ngaysinh_nam"] + "");
                                break;
                            case ENUM_QH_NHANTHAN.ME:
                                objBA.HOTENME = item["HoTen"] + "";
                                objBA.NAMSINHME = String.IsNullOrEmpty(item["Ngaysinh_nam"] + "") ? 0 : Convert.ToDecimal(item["Ngaysinh_nam"] + "");
                                break;
                        }
                    }
                }
                #endregion

                objBA.TOIDANH = "";
                objBA.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_BIAN.Add(objBA);
                dt.SaveChanges();
                hddBiAnID.Value = objBA.ID.ToString();
                THA_SOTHAM_CAOTRANG_DIEULUAT tha_caotrang_dieuluat = new THA_SOTHAM_CAOTRANG_DIEULUAT();
                List<AHS_SOTHAM_CAOTRANG_DIEULUAT> ahs_caotrang_dieuluat = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == bian_hethong_id && x.VUANID == vuan_hethong_id).ToList();
                if (ahs_caotrang_dieuluat != null)
                {
                    foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT dr in ahs_caotrang_dieuluat)
                    {
                        tha_caotrang_dieuluat.BICANID = objBA.ID;
                        tha_caotrang_dieuluat.CAOTRANGID = dr.CAOTRANGID;
                        tha_caotrang_dieuluat.DIEULUATID = dr.DIEULUATID;
                        tha_caotrang_dieuluat.ISMAIN = dr.ISMAIN;
                        tha_caotrang_dieuluat.NGAYTAO = DateTime.Now;
                        tha_caotrang_dieuluat.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        tha_caotrang_dieuluat.TENTOIDANH = dr.TENTOIDANH;
                        tha_caotrang_dieuluat.TOIDANHID = dr.TOIDANHID;
                        tha_caotrang_dieuluat.VUANID = objBA.VUANID;

                        dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Add(tha_caotrang_dieuluat);
                        dt.SaveChanges();
                    }
                }
            }
        }
    }
}