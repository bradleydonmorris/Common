
namespace SimpleMarkdown
{
	partial class Form_Main
	{
		/// <summary>
		///  Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		///  Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		///  Required method for Designer support - do not modify
		///  the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.TextBox_Markdown = new System.Windows.Forms.TextBox();
			this.SplitContainer_Markdown = new System.Windows.Forms.SplitContainer();
			this.Panel_MarkdownPreview = new System.Windows.Forms.Panel();
			this.WebView2_Markdown = new Microsoft.Web.WebView2.WinForms.WebView2();
			this.SaveFileDialog_Markdown = new System.Windows.Forms.SaveFileDialog();
			this.OpenFileDialog_Markdown = new System.Windows.Forms.OpenFileDialog();
			((System.ComponentModel.ISupportInitialize)(this.SplitContainer_Markdown)).BeginInit();
			this.SplitContainer_Markdown.Panel1.SuspendLayout();
			this.SplitContainer_Markdown.Panel2.SuspendLayout();
			this.SplitContainer_Markdown.SuspendLayout();
			this.Panel_MarkdownPreview.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.WebView2_Markdown)).BeginInit();
			this.SuspendLayout();
			// 
			// TextBox_Markdown
			// 
			this.TextBox_Markdown.AllowDrop = true;
			this.TextBox_Markdown.Dock = System.Windows.Forms.DockStyle.Fill;
			this.TextBox_Markdown.Location = new System.Drawing.Point(0, 0);
			this.TextBox_Markdown.Multiline = true;
			this.TextBox_Markdown.Name = "TextBox_Markdown";
			this.TextBox_Markdown.ScrollBars = System.Windows.Forms.ScrollBars.Both;
			this.TextBox_Markdown.Size = new System.Drawing.Size(381, 450);
			this.TextBox_Markdown.TabIndex = 0;
			this.TextBox_Markdown.TextChanged += new System.EventHandler(this.TextBox_Markdown_TextChanged);
			this.TextBox_Markdown.DragDrop += new System.Windows.Forms.DragEventHandler(this.TextBox_Markdown_DragDrop);
			this.TextBox_Markdown.DragEnter += new System.Windows.Forms.DragEventHandler(this.TextBox_Markdown_DragEnter);
			// 
			// SplitContainer_Markdown
			// 
			this.SplitContainer_Markdown.Cursor = System.Windows.Forms.Cursors.VSplit;
			this.SplitContainer_Markdown.Dock = System.Windows.Forms.DockStyle.Fill;
			this.SplitContainer_Markdown.Location = new System.Drawing.Point(0, 0);
			this.SplitContainer_Markdown.Name = "SplitContainer_Markdown";
			// 
			// SplitContainer_Markdown.Panel1
			// 
			this.SplitContainer_Markdown.Panel1.Controls.Add(this.TextBox_Markdown);
			// 
			// SplitContainer_Markdown.Panel2
			// 
			this.SplitContainer_Markdown.Panel2.Controls.Add(this.Panel_MarkdownPreview);
			this.SplitContainer_Markdown.Size = new System.Drawing.Size(800, 450);
			this.SplitContainer_Markdown.SplitterDistance = 381;
			this.SplitContainer_Markdown.TabIndex = 2;
			// 
			// Panel_MarkdownPreview
			// 
			this.Panel_MarkdownPreview.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.Panel_MarkdownPreview.Controls.Add(this.WebView2_Markdown);
			this.Panel_MarkdownPreview.Dock = System.Windows.Forms.DockStyle.Fill;
			this.Panel_MarkdownPreview.Location = new System.Drawing.Point(0, 0);
			this.Panel_MarkdownPreview.Name = "Panel_MarkdownPreview";
			this.Panel_MarkdownPreview.Size = new System.Drawing.Size(415, 450);
			this.Panel_MarkdownPreview.TabIndex = 1;
			// 
			// WebView2_Markdown
			// 
			this.WebView2_Markdown.CreationProperties = null;
			this.WebView2_Markdown.DefaultBackgroundColor = System.Drawing.Color.White;
			this.WebView2_Markdown.Dock = System.Windows.Forms.DockStyle.Fill;
			this.WebView2_Markdown.Location = new System.Drawing.Point(0, 0);
			this.WebView2_Markdown.Name = "WebView2_Markdown";
			this.WebView2_Markdown.Size = new System.Drawing.Size(413, 448);
			this.WebView2_Markdown.Source = new System.Uri("about:blank", System.UriKind.Absolute);
			this.WebView2_Markdown.TabIndex = 0;
			this.WebView2_Markdown.ZoomFactor = 1D;
			this.WebView2_Markdown.CoreWebView2InitializationCompleted += new System.EventHandler<Microsoft.Web.WebView2.Core.CoreWebView2InitializationCompletedEventArgs>(this.WebView2_Markdown_CoreWebView2InitializationCompleted);
			// 
			// Form_Main
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(800, 450);
			this.Controls.Add(this.SplitContainer_Markdown);
			this.Name = "Form_Main";
			this.Text = "Markdown Editor";
			this.Load += new System.EventHandler(this.Form_Main_Load);
			this.SplitContainer_Markdown.Panel1.ResumeLayout(false);
			this.SplitContainer_Markdown.Panel1.PerformLayout();
			this.SplitContainer_Markdown.Panel2.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.SplitContainer_Markdown)).EndInit();
			this.SplitContainer_Markdown.ResumeLayout(false);
			this.Panel_MarkdownPreview.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.WebView2_Markdown)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.TextBox TextBox_Markdown;
		private System.Windows.Forms.SplitContainer SplitContainer_Markdown;
		private System.Windows.Forms.Panel Panel_MarkdownPreview;
		private Microsoft.Web.WebView2.WinForms.WebView2 WebView2_Markdown;
		private System.Windows.Forms.SaveFileDialog SaveFileDialog_Markdown;
		private System.Windows.Forms.OpenFileDialog OpenFileDialog_Markdown;
	}
}

