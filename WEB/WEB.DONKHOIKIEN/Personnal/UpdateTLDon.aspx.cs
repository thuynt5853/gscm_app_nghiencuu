using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Module.Common;
using System.Globalization;
using System.IO;

using DAL.GSTP;
using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;
using BL.GSTP.Danhmuc;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class UpdateTLDon : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();

        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";

                if (!IsPostBack)
                {
                    Decimal DonID = Convert.ToDecimal(Request["vID"] + "");
                    hddDonKKID.Value = DonID.ToString();
                    LoadInfo(DonID);
                    LoadFileTheoDon();
                }
                //-----------them doan dk cho su kien upload file ------------------
                ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
                scriptManager.RegisterPostBackControl(this.cmdThemFileTL);
            }
            else Response.Redirect("/Trangchu.aspx");
        }

        void LoadInfo(Decimal DonID)
        {
            hddDonKKID.Value = DonID.ToString();
            DONKK_DON objDonKK = dt.DONKK_DON.Where(x => x.ID == DonID).Single<DONKK_DON>();
            if (objDonKK != null)
            {
                Decimal dTemp = 0;
                hddStatusDonKK.Value = objDonKK.TRANGTHAI + "";
                //--------load thong tin vu an theo loai----------------------
                Decimal VuViecID = Convert.ToDecimal(objDonKK.VUANID);
                hddVuAnID.Value = VuViecID.ToString();

                String loai_vuviec = objDonKK.MALOAIVUAN;
                hddMaLoaiVuViec.Value = loai_vuviec;

                lttVuViec.Text = objDonKK.TENVUVIEC;
                dTemp = (Decimal)objDonKK.TOAANID;

                //------Load thong tin vu viec------------------
                DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.ID == dTemp).SingleOrDefault();
                if (objTA != null)
                    lttToaAn.Text = objTA.TEN;

                //---------------------
                String yeucau_don = "";
                switch (Convert.ToInt32(objDonKK.TRANGTHAI.GetValueOrDefault(0)))
                {
                    case 0:
                        //đ
                        yeucau_don = "Đơn đã gửi và chờ giải quyết";
                        break;
                    case 1:
                        //chuyen don trong nganh
                        yeucau_don = "Đơn được chuyển tới " + objDonKK.YEUCAU;
                        break;
                    case 2:
                        //chuyen don ngoai nganh 
                        yeucau_don = "Đơn được chuyển tới " + objDonKK.YEUCAU;
                        break;
                    case 3:
                        //tra lai don
                        yeucau_don = "Đơn bị Tòa án trả lại"
                                     + ((string.IsNullOrEmpty(objDonKK.YEUCAU + "")) ? "" : "<br/>Lý do: " + objDonKK.YEUCAU);
                        break;
                    case 4:
                        //yeu cau bo sung
                        yeucau_don = "Đơn chờ bổ sung theo yêu cầu của Tòa án"
                                     + ((string.IsNullOrEmpty(objDonKK.YEUCAU + "")) ? "" : "<br/>Yêu cầu: " + objDonKK.YEUCAU);
                        break;
                    case 5:
                        //yeu cau bo sung
                        yeucau_don = "Đơn đã được thụ lý";
                        break;
                }
                lttYeuCauBoSung.Text = yeucau_don;
            }
        }
        protected void cmdThemFileTL_Click(object sender, EventArgs e)
        {
            SaveFile_KySo();
            txtTenTaiLieu.Text = "";
            LoadFileTheoDon();
        }

        protected void cmdGuiDon_Click(object sender, EventArgs e)
        {
            int StatusDonKK = (string.IsNullOrEmpty(hddStatusDonKK.Value)) ?10:Convert.ToInt16( hddStatusDonKK.Value);
            string MaLoaiVuViec = hddMaLoaiVuViec.Value;
            Decimal DonID = Convert.ToDecimal(Request["vID"] + "");
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonID 
                                                                       && x.ISBOSUNGGSTP == 0).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count>0)
            {
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    Update_QLAn_TaiLieu(item, MaLoaiVuViec);
                    item.ISBOSUNGGSTP = 1;
                }
                dt.SaveChanges();
             
                //----------------------
                if (StatusDonKK== 4)
                {
                    //Don KK cho bo sung theo yeu cau cua toa
                    DONKK_DON obj = dt.DONKK_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    obj.TRANGTHAI =0;
                    dt.SaveChanges();
                }
                LoadFileTheoDon();

                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Đơn khởi kiện đã được bổ sung tài liệu thành công!");
                Response.Redirect("ChiTietDon.aspx?ID=" + Request["vID"].ToString());
            }
            else
            {
                Cls_Comon.ShowMessage(this, this.GetType(),"Thông báo", "Bạn chưa bổ sung thêm bất cứ tài liệu nào. Hãy kiểm tra lại!");
                Cls_Comon.SetFocus(this, this.GetType(), txtTenTaiLieu.ClientID);
            }
        }
        //void UploadFile()
        //{
        //    byte[] buff = null;
        //    String file_path = hddFilePath.Value;
        //    String MaLoaiVuViec = hddMaLoaiVuViec.Value;
        //    Decimal DonID = Convert.ToDecimal(hddDonKKID.Value);
        //    decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);

        //    DONKK_DON_TAILIEU obj = new DONKK_DON_TAILIEU();
        //    string folder_upload = "/TempUpload";
        //    string strPath = Server.MapPath(folder_upload);
        //    if (!Directory.Exists(strPath))
        //    {
        //        try
        //        {
        //            Directory.CreateDirectory(strPath);
        //        }
        //        catch (Exception ex)
        //        {
        //            throw ex;
        //        }
        //    }

        //    string filename = "";
        //    if (fileupload.HasFiles)
        //    {
        //        //-----upload file len server
        //        filename = Path.GetFileName(fileupload.PostedFile.FileName);
        //        decimal file_size = fileupload.PostedFile.ContentLength / 1024 / 1024;
        //        if (file_size <= 2)
        //        {
        //            file_path = strPath + "\\" + filename;
        //            fileupload.PostedFile.SaveAs(file_path);

        //            //----------doc file vua duoc upload len server de lay noi dung-------------
        //            using (FileStream fs = File.OpenRead(file_path))
        //            {
        //                BinaryReader br = new BinaryReader(fs);
        //                FileInfo oF = new FileInfo(file_path);
        //                long numBytes = oF.Length;
        //                buff = br.ReadBytes((int)numBytes);

        //                obj = new DONKK_DON_TAILIEU();
        //                obj.DONID = DonID;
        //                obj.TAILIEUID = 0;
        //                obj.TENFILE = oF.Name;
        //                obj.LOAIFILE = oF.Extension;
        //                obj.TENTAILIEU = (String.IsNullOrEmpty(txtTenTaiLieu.Text.Trim() + "")) ? oF.Name : txtTenTaiLieu.Text.Trim();
        //                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
        //                obj.DKKUSERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
        //                obj.NGAYTAO = DateTime.Now;
        //                obj.NOIDUNG = buff;
        //                obj.LOAIDON = MaLoaiVuViec;

        //                dt.DONKK_DON_TAILIEU.Add(obj);
        //                dt.SaveChanges();
        //            }
        //            Update_QLAn_TaiLieu(obj, MaLoaiVuViec);
        //            //xoa file
        //            File.Delete(file_path);
        //        }
        //        else
        //        {
        //            string temp = "Kích thước tài liệu đang chọn quá 2MB. Hãy kiểm tra lại";
        //            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", temp);
        //        }
        //    }
        //}

        void SaveFile_KySo()
        {
            string folder_upload = "/TempUpload/";
            string file_kyso = hddFileKySo.Value;
            String MaLoaiVuViec = hddMaLoaiVuViec.Value;
            Decimal DonID = Convert.ToDecimal(hddDonKKID.Value);
            decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);
            
            if (!String.IsNullOrEmpty(hddFileKySo.Value))
            {
                String[] arr = file_kyso.Split('/');
                string file_name = arr[arr.Length - 1] + "";
                String file_path = Path.Combine(Server.MapPath(folder_upload), file_name);
                DONKK_DON_TAILIEU obj = new DONKK_DON_TAILIEU();

                byte[] buff = null;

                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(file_path);
                    long numBytes = oF.Length;
                    buff = br.ReadBytes((int)numBytes);

                    obj = new DONKK_DON_TAILIEU();
                    obj.DONID = DonID;
                    obj.TAILIEUID = 0;
                    obj.TENFILE = oF.Name;
                    obj.LOAIFILE = oF.Extension;
                    obj.TENTAILIEU = (String.IsNullOrEmpty(txtTenTaiLieu.Text.Trim() + "")) ? oF.Name : txtTenTaiLieu.Text.Trim();
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.DKKUSERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    obj.NGAYTAO = DateTime.Now;
                    obj.NOIDUNG = buff;
                    obj.LOAIDON = MaLoaiVuViec;
                    obj.ISBOSUNGGSTP = 0;
                    dt.DONKK_DON_TAILIEU.Add(obj);
                    dt.SaveChanges();
                }
                // Update_QLAn_TaiLieu(obj, MaLoaiVuViec);
                //xoa file
                File.Delete(file_path);
            }
        }
        
        void Update_QLAn_TaiLieu(DONKK_DON_TAILIEU obj, String MaLoaiVuViec)
        {
            Decimal DonID = Convert.ToDecimal(hddDonKKID.Value);
            decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);
            string UserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            Decimal UserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            #region Update QLAn tai lieu
            DONKK_DON_DUONGSU objDS = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonID 
                                                                        && x.NGUOITAO == UserName
                                                                        && x.EMAIL == UserName
                                                                       ).Single<DONKK_DON_DUONGSU>();
            if (objDS != null)
            {
                Decimal QLA_DuongSuId = (Decimal)objDS.DUONGSUID;
                switch (MaLoaiVuViec)
                {
                    case ENUM_LOAIAN.AN_DANSU:
                        ADS_File(obj, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_HANHCHINH:
                        AHC_File(obj, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        AHN_File(obj, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        AKT_File(obj, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_LAODONG:
                        ALD_File(obj, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_PHASAN:
                        APS_File(obj, QLA_DuongSuId);
                        break;
                }
            }            
            #endregion
        }
       
        #region Update QuanLyAn GSTP. TaiLieuBanGiao

        void ADS_File(DONKK_DON_TAILIEU item, Decimal QLA_DuongSuId)
        {
            decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);

            ADS_DON_TAILIEU objTL = new ADS_DON_TAILIEU();
            if (item != null)
            {
                objTL = new ADS_DON_TAILIEU();
                objTL.DONID = VuAnID;
                objTL.BANGIAOID = 0;
                objTL.LOAIFILE = item.LOAIFILE;
                objTL.TENFILE = item.TENFILE;
                objTL.NOIDUNG = item.NOIDUNG;
                objTL.TENTAILIEU = item.TENTAILIEU;
                objTL.NGAYTAO = DateTime.Now;
                objTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                objTL.NGUOIBANGIAO = QLA_DuongSuId;
                objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                objTL.NGUOINHANID = 0;

                gsdt.ADS_DON_TAILIEU.Add(objTL);
                gsdt.SaveChanges();
            }

            //------------ban giao tai lieu-------------------------
            try
            {
                ADS_DON_BANGIAO_TAILIEU objBG = null;
                objBG = new ADS_DON_BANGIAO_TAILIEU();
                objBG.DONID = VuAnID;
                objBG.NGAYBANGIAO = DateTime.Now;
                objBG.NGAYTAO = DateTime.Now;
                objBG.NGUOIBANGIAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                objBG.NGUOINHANID = 0;
                gsdt.ADS_DON_BANGIAO_TAILIEU.Add(objBG);

                gsdt.SaveChanges();
            } catch (Exception ex) { }
        }
        void AHC_File(DONKK_DON_TAILIEU item, Decimal QLA_DuongSuId)
        {
            decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);

            AHC_DON_TAILIEU objTL = null;
            if (item != null)
            {
                objTL = new AHC_DON_TAILIEU();
                objTL.DONID = VuAnID;
                objTL.BANGIAOID = 0;
                objTL.LOAIFILE = item.LOAIFILE;
                objTL.TENFILE = item.TENFILE;
                objTL.NOIDUNG = item.NOIDUNG;
                objTL.TENTAILIEU = item.TENTAILIEU;
                objTL.NGAYTAO = DateTime.Now;
                objTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                objTL.NGUOIBANGIAO = QLA_DuongSuId;
                objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                objTL.NGUOINHANID = 0;

                gsdt.AHC_DON_TAILIEU.Add(objTL);
                gsdt.SaveChanges();
            }
            //------------ban giao tai lieu-------------------------
            try
            {
                AHC_DON_BANGIAO_TAILIEU objBG = null;
                objBG = new AHC_DON_BANGIAO_TAILIEU();
                objBG.DONID = VuAnID;
                objBG.NGAYBANGIAO = DateTime.Now;
                objBG.NGAYTAO = DateTime.Now;
                objBG.NGUOIBANGIAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                objBG.NGUOINHANID = 0;
                gsdt.AHC_DON_BANGIAO_TAILIEU.Add(objBG);
                gsdt.SaveChanges();
            }
            catch (Exception ex) { }
        }
        void AHN_File(DONKK_DON_TAILIEU item, Decimal QLA_DuongSuId)
        {
            decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);
            AHN_DON_TAILIEU objTL = new AHN_DON_TAILIEU();
            if (item != null)
            {
                objTL = new AHN_DON_TAILIEU();
                objTL.DONID = VuAnID;
                objTL.BANGIAOID = 0;
                objTL.LOAIFILE = item.LOAIFILE;
                objTL.TENFILE = item.TENFILE;
                objTL.NOIDUNG = item.NOIDUNG;
                objTL.TENTAILIEU = item.TENTAILIEU;
                objTL.NGAYTAO = DateTime.Now;
                objTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                objTL.NGUOIBANGIAO = QLA_DuongSuId;
                objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                objTL.NGUOINHANID = 0;

                gsdt.AHN_DON_TAILIEU.Add(objTL);
                gsdt.SaveChanges();
            }

            //------------ban giao tai lieu-------------------------
            try
            {
                AHN_DON_BANGIAO_TAILIEU objBG = null;
                objBG = new AHN_DON_BANGIAO_TAILIEU();
                objBG.DONID = VuAnID;
                objBG.NGAYBANGIAO = DateTime.Now;
                objBG.NGAYTAO = DateTime.Now;
                objBG.NGUOIBANGIAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                objBG.NGUOINHANID = 0;
                gsdt.AHN_DON_BANGIAO_TAILIEU.Add(objBG);
                gsdt.SaveChanges();
            }
            catch (Exception ex) { }
        }
        void ALD_File(DONKK_DON_TAILIEU item, Decimal QLA_DuongSuId)
        {
            decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);

            ALD_DON_TAILIEU objTL = new ALD_DON_TAILIEU();
            objTL.DONID = VuAnID;
            objTL.BANGIAOID = 0;
            objTL.LOAIFILE = item.LOAIFILE;
            objTL.TENFILE = item.TENFILE;
            objTL.NOIDUNG = item.NOIDUNG;
            objTL.TENTAILIEU = item.TENTAILIEU;
            objTL.NGAYTAO = DateTime.Now;
            objTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            objTL.NGUOIBANGIAO = QLA_DuongSuId;
            objTL.LOAIDOITUONG = 0;//=0--> nguyendon
            objTL.NGUOINHANID = 0;

            gsdt.ALD_DON_TAILIEU.Add(objTL);
            gsdt.SaveChanges();
            //-------------------------
            ALD_DON_BANGIAO_TAILIEU objBG = null;
            objBG = new ALD_DON_BANGIAO_TAILIEU();
            objBG.DONID = VuAnID;
            objBG.NGAYBANGIAO = DateTime.Now;
            objBG.NGAYTAO = DateTime.Now;
            objBG.NGUOIBANGIAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            objBG.NGUOINHANID = 0;
            gsdt.ALD_DON_BANGIAO_TAILIEU.Add(objBG);
            gsdt.SaveChanges();
        }
        void AKT_File(DONKK_DON_TAILIEU item, Decimal QLA_DuongSuId)
        {
            decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);

            AKT_DON_TAILIEU objTL = new AKT_DON_TAILIEU();
            objTL.DONID = VuAnID;
            objTL.BANGIAOID = 0;
            objTL.LOAIFILE = item.LOAIFILE;
            objTL.TENFILE = item.TENFILE;
            objTL.NOIDUNG = item.NOIDUNG;
            objTL.TENTAILIEU = item.TENTAILIEU;
            objTL.NGAYTAO = DateTime.Now;
            objTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            objTL.NGUOIBANGIAO = QLA_DuongSuId;
            objTL.LOAIDOITUONG = 0;//=0--> nguyendon
            objTL.NGUOINHANID = 0;

            gsdt.AKT_DON_TAILIEU.Add(objTL);
            gsdt.SaveChanges();

            //------------ban giao tai lieu-------------------------
            try
            {
                AKT_DON_BANGIAO_TAILIEU objBG = null;
                objBG = new AKT_DON_BANGIAO_TAILIEU();
                objBG.DONID = VuAnID;
                objBG.NGAYBANGIAO = DateTime.Now;
                objBG.NGAYTAO = DateTime.Now;
                objBG.NGUOIBANGIAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                objBG.NGUOINHANID = 0;
                gsdt.AKT_DON_BANGIAO_TAILIEU.Add(objBG);
                gsdt.SaveChanges();
            }
            catch (Exception ex) { }
        }
        void APS_File(DONKK_DON_TAILIEU item, Decimal QLA_DuongSuId)
        {
            decimal VuAnID = String.IsNullOrEmpty(hddVuAnID.Value) ? 0 : Convert.ToDecimal(hddVuAnID.Value);

            APS_DON_TAILIEU objTL = new APS_DON_TAILIEU();
            objTL.DONID = VuAnID;
            objTL.BANGIAOID = 0;
            objTL.LOAIFILE = item.LOAIFILE;
            objTL.TENFILE = item.TENFILE;
            objTL.NOIDUNG = item.NOIDUNG;
            objTL.TENTAILIEU = item.TENTAILIEU;
            objTL.NGAYTAO = DateTime.Now;
            objTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            objTL.NGUOIBANGIAO = QLA_DuongSuId;
            objTL.LOAIDOITUONG = 0;//=0--> nguyendon
            objTL.NGUOINHANID = 0;

            gsdt.APS_DON_TAILIEU.Add(objTL);
            gsdt.SaveChanges();

            //------------ban giao tai lieu-------------------------
            try
            {
                APS_DON_BANGIAO_TAILIEU objBG = null;
                objBG = new APS_DON_BANGIAO_TAILIEU();
                objBG.DONID = VuAnID;
                objBG.NGAYBANGIAO = DateTime.Now;
                objBG.NGAYTAO = DateTime.Now;
                objBG.NGUOIBANGIAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                objBG.NGUOINHANID = 0;
                gsdt.APS_DON_BANGIAO_TAILIEU.Add(objBG);
                gsdt.SaveChanges();
            }
            catch (Exception ex) { }
        }
        #endregion

        void LoadFileTheoDon()
        {
            Decimal DonKKID = (string.IsNullOrEmpty(hddDonKKID.Value)) ? 0 : Convert.ToDecimal(hddDonKKID.Value);
            String MaLoaiVuViec = hddMaLoaiVuViec.Value;
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID
                                                                       && x.LOAIDON == MaLoaiVuViec
                                                                       && x.DKKUSERID == UserID
                                                                       && x.TAILIEUID == 0
                                                                       && x.ISBOSUNGGSTP == 0
                                                                    ).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                rptFile.DataSource = lst;
                rptFile.DataBind();
                rptFile.Visible = true;
            }
            else rptFile.Visible = false;

            //lttThaoTacFile.Text = "<td style ='width: 70px;'> Thao tác </td>";
        }

        protected void rptFile_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "dowload":
                    DowloadFile(Convert.ToDecimal(e.CommandArgument));
                    break;
                case "Delete":
                    //XoaFile(Convert.ToDecimal(e.CommandArgument));
                    //LoadFileTheoDon();
                    break;
            }
        }
        void DowloadFile(Decimal FileID)
        {
            try
            {
                DONKK_DON_TAILIEU oND = dt.DONKK_DON_TAILIEU.Where(x => x.ID == FileID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.LOAIFILE + "';", true);
                }
            }
            catch (Exception ex)
            {
                lttThongBao.Text = ex.Message;
            }
        }
        void XoaFile(Decimal TaiLieuID)
        {
            Decimal DonKKID = (string.IsNullOrEmpty(hddDonKKID.Value + "")) ? 0 : Convert.ToDecimal(hddDonKKID.Value);
            string folder_upload = "/TempUpload";
            string strPath = Server.MapPath(folder_upload);
            string file_path = "";
            DONKK_DON_TAILIEU obj = dt.DONKK_DON_TAILIEU.Where(x => x.DKKUSERID == UserID
                                                                 && x.DONID == DonKKID
                                                                 && x.ID == TaiLieuID).Single<DONKK_DON_TAILIEU>();
            if (obj != null)
            {
                dt.DONKK_DON_TAILIEU.Remove(obj);
                dt.SaveChanges();

                file_path = strPath + "\\" + obj.TENFILE;
                File.Delete(file_path);
                lttThongBao.Text = "Tài liệu được xóa thành công!";
            }
        }
    }
}