<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Quantri.Phanhe.Danhsach" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
<div class="box">
   
    <div class="box_nd">
        <div class="truong">
            <table class="table1">
                 <tr>
                    <td >
                        Chương trình<asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label> 
                   
                    </td>
                    <td>
                       <asp:DropDownList ID="ddlHethong"   CssClass="chosen-select" runat="server" Width="200px"></asp:DropDownList>
                      
                    </td>
                </tr>
                <tr>
                    <td style="width: 140px;">
                       Mã phân hệ<asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label> 
                   
                    </td>
                    <td>
                        <asp:TextBox ID="txtMaChuongTrinh" runat="server" CssClass="user" Width="150px" MaxLength="250" 
                            ToolTip="Nhập mã chương trình" />
                      
                    </td>
                </tr>
                <tr>
                    <td>
                        Tên phân hệ <asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label> 
                   
                    </td>
                    <td>
                        <asp:TextBox ID="txtTenChuongTrinh" runat="server" Width="99%" CssClass="user" MaxLength="500"
                            ToolTip="Nhập tên chương trình" />
                      
                    </td>
                </tr>               
                <tr>
                    <td>
                        Hiệu lực
                    </td>
                    <td>
                        <asp:CheckBox ID="chkHieuluc" runat="server" Text="" ToolTip="Tính hiệu lực của CT" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Có khung thông tin dưới MENU
                    </td>
                    <td>
                        <asp:CheckBox ID="chkNhomTDGS" runat="server" Text="" />
                        <i>(Nhóm các menu chức năng có khung ghim thông tin phía dưới Tab menu)</i>
                    </td>
                </tr>
                <tr>
                    <td>
                       Thứ tự
                    </td>
                    <td>
                        <asp:DropDownList CssClass="user" ID="dropThutu" Width="50px" runat="server" ToolTip="Lựa chọn thứ tự cho chương trình">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="bt" style="margin-left: 150px;">
              <asp:button id="cmdUpdate" runat="server" cssclass="buttoninput" text="Lưu"  onclick="btnCapNhat_Click"  />
             
                <asp:button id="cmdLammoi" runat="server" cssclass="buttoninput" text="Làm mới" onclick="btnLammoi_Click" />

               <asp:button id="cmdDel" runat="server" cssclass="buttoninput" text="Hủy Lưu" onclick="btnHuyCapNhat_Click"  />
                   
        </div>
        <div>
            <asp:Label ID="lblmgs" ForeColor="Red" runat="server"></asp:Label>
            <asp:HiddenField ID="hddchuongtrinhID" runat="server" Value="0" />
        </div>
          <table style="width: 300px; margin-top: 10px; border-spacing: 5px;">
                                            <tr>
                                                <td style="width: 150px;">
                                                    <asp:DropDownList ID="ddlHethongTK"   CssClass="chosen-select" runat="server" Width="200px"></asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Button ID="Btntimkiem" runat="server" CssClass="buttoninput btnTimKiemCss" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />
                                                </td>
                                            </tr>
                                        </table>
        <div class="phantrang">
            <div class="sobanghi">
                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
            </div>
            <div class="sotrang">
                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                    OnClick="lbTBack_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                    OnClick="lbTNext_Click"></asp:LinkButton>
            </div>
        </div>
        <div>
            <asp:DataGrid ID="dgrDanhMucCT" runat="server" AutoGenerateColumns="False" CellPadding="4"
                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgrDanhMucCT_ItemCommand">
                <Columns>
                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                    <asp:TemplateColumn HeaderStyle-Width="30px">
                        <HeaderTemplate>
                            Thứ tự
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("THUTU")%>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:TemplateColumn>
                   
                    <asp:TemplateColumn >
                        <HeaderTemplate>
                            Tên phân hệ
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("TEN") %>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn ItemStyle-Width="140px" >
                        <HeaderTemplate>
                           Thuộc chương trình
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:HiddenField ID="hddHethongID" runat="server" Value='<%#Eval("HETHONGID") %>' />
                           <asp:Literal ID="lstChuongtrinh" runat="server"></asp:Literal>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" ></HeaderStyle>
                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                    </asp:TemplateColumn>
                     <asp:TemplateColumn ItemStyle-Width="70px" HeaderStyle-Width="70px">
                        <HeaderTemplate>
                            Mã phân hệ
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#Eval("MA")%>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" Width="60px"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn ItemStyle-Width="70px"  HeaderStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Hiệu lực
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# Eval("HIEULUC").ToString().ToUpper() =="1" ? "Có hiệu lực" : "Không có hiệu lực"%>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderStyle-Width="80px"  HeaderStyle-HorizontalAlign="Center">
                        <HeaderTemplate>
                            Thao tác
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="sua"  ForeColor="#0e7eee"
                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                            &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa"  ForeColor="#0e7eee"
                                CommandName="xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa chương trình này?');"></asp:LinkButton>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:TemplateColumn>
                </Columns>
                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false">
                </PagerStyle>
                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            </asp:DataGrid>
        </div>
        <div class="phantrang">
            <div class="sobanghi">
                <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
            </div>
            <div class="sotrang">
                <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                    OnClick="lbTBack_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                    OnClick="lbTNext_Click"></asp:LinkButton>
            </div>
        </div>
    </div>
</div>
     <script language="javascript" type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }      
    </script>
</asp:Content>
